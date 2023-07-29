import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/models/order_detail.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OrderDetailsAdapter extends StatefulWidget {

  OrderDetail order;

  OrderDetailsAdapter({this.order});

  @override
  State<OrderDetailsAdapter> createState() => _OrderDetailsAdapterState();

}

class _OrderDetailsAdapterState extends State<OrderDetailsAdapter> {

  List<int> ids = [];

  DbHelper db_helper = DbHelper();

  AppUser user;

  bool isLoading = false;

  double amount;

  @override
  Widget build(BuildContext context) {

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(widget.order.timestamp);
    DateFormat formatter = DateFormat('d MMM y');
    String formattedDate = formatter.format(dateTime);

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      elevation: 3,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(15),
        child: isLoading ? Center(child: CircularProgressIndicator(),) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              alignment: Alignment.centerRight,
              child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () async {
                                  if (widget.order.paymentStatus != "Pay on delivery") {
                                    Navigator.pop(context);
                                    await cancelOrder();
                                  }
                                },
                                child: Text('Cancel order', style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'inter-medium',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ),
                            )
                        );
                      },
                    );
                  },
                child: Icon(Icons.more_vert, color: Colors.black,)
              ),
            ),
            Text(formattedDate, style: TextStyle(
              color: HexColor("#808080"),
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'inter-medium',
            ),),
            Container(height: 8,),
            Text("Payment status: "+widget.order.paymentStatus, style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-medium',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),),
            Container(height: 8,),
            Text("Delivery status: "+widget.order.deliveryStatus, style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-medium',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),),
            Container(height: 8,),
            Text("Notes: "+widget.order.desc, style: TextStyle(
              color: HexColor("#808080"),
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'inter-medium',
            ),),
            Container(height: 5,),
            Divider(),
            Container(height: 5,),
            ListView.builder(
              itemCount: ids.length,
              shrinkWrap: true,
              controller: ScrollController(),
              itemBuilder: (context, index) {
                return OrderItem(
                  id: ids[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cancelOrder () async {
    await db_helper.updateOrderStatus(widget.order.orderID, widget.order.invoice_id, "Order cancelled", "Delivery cancelled");
    await sendNotification();
    showToast("Your order has been cancelled and a refund will be processed");
  }

  Future<void> sendNotificationToToken(String fcmToken) async {
    // Replace YOUR_SERVER_KEY with your Firebase Server Key from Firebase Console
    final String serverKey = "AAAAMuXbrLo:APA91bHCih8jQi9cVDPs6othxRLkB2kII3V9CbqzJeMYaqcNoE6tekWXPwRUd8V6RYmlD9K4UtX5qoyTJkAI80EeFA0AK2FUKjHC6loBJOAIVOsBGcpbIoSE4Uh4p0-eAMMM1xfmGgEU";

    // Define the FCM API endpoint
    final String fcmEndpoint = "https://fcm.googleapis.com/fcm/send";

    // Define the notification payload
    final Map<String, dynamic> notification = {
      "title": "Order cancelled",
      "body": "Order placed by ${user.phoneNumber} has been cancelled, check app for more details",
      "sound": "default",
      "badge": "1",
    };

    // Define the data payload (optional, can be used to pass additional data)
    final Map<String, dynamic> data = {
      "key1": "value1",
      "key2": "value2",
    };

    // Define the message payload
    final Map<String, dynamic> message = {
      "notification": notification,
      "data": data,
      "to": fcmToken,
    };

    // Encode the message to JSON
    final String encodedMessage = jsonEncode(message);

    try {
      // Send the HTTP POST request to the FCM API endpoint
      final http.Response response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: encodedMessage,
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully!");
      } else {
        print("Failed to send notification. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  Future<void> sendNotification () async {
    String token = "";
    final snapshot = await FirebaseDatabase.instance.ref().child('data/token/').get();
    final list = snapshot.children;
    list.forEach((element) async {
      token = element.child("token").value.toString();
    });
    await sendNotificationToToken(token);
  }

  // Future<void> cancelOrder () async {
  //   showToast("Your order is being cancelled");
  //   final provider = {
  //     '"provider"': '"M-PESA"',
  //     '"value"': '"320.0"'
  //   };
  //   final invoice = {
  //     '"invoice"': "${provider.toString()}"
  //   };
  //   final params = {
  //     '"transaction"': "${invoice.toString()}",
  //     '"reason"': '"Cancelled order"',
  //     '"amount"': '"${amount.toString()}"',
  //   };
  //
  //   print(params);
  //   var url = Uri.parse('https://payment.intasend.com/api/v1/chargebacks/');
  //   var headers = {
  //     'content-type': 'application/json',
  //     'accept': 'application/json',
  //     'Authorization': 'Bearer ISSecretKey_live_8ff0aabc-17a6-44d1-a2a5-339c5fc8947d',
  //   };
  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: headers,
  //       body: jsonEncode(params),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print(response.body.toString());
  //     } else {
  //       print('Error posting data: ${response.body.toString()}');
  //     }
  //   } catch (e) {
  //     print('Exception caught: $e');
  //   }
  // }

  Future<void> checkStatus (String invoice_id) async {
    final params = {
      "invoice_id": invoice_id,
      "public_key": "ISPubKey_live_849e32a1-7214-46b4-9b1b-cdce60c43142"
    };

    var url = Uri.parse('https://payment.intasend.com/api/v1/payment/status/');

    var headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Basic ZDhzdFI1WEFBNEtYWFdnQjluclhzN1ZZR2ZkamQ1dEQ6bnV5ZWZtYlNDWDZCZDJVeg==',
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        print(response.body.toString());
        Map<String, dynamic> data = jsonDecode(response.body.toString());
        String invoiceID = data["invoice"]["invoice_id"];
        String status = data["invoice"]["state"];
        amount = data["invoice"]["net_amount"];
        await db_helper.updateOrderStatus(widget.order.orderID, invoiceID, status, widget.order.deliveryStatus);
      } else {
        print('Error posting data: ${response.body.toString()}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }

  }

  Future<void> init () async {
    user = await db_helper.getUser();
    ids = widget.order.selectedItems
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '')
        .split(',')
        .map((e) => int.parse(e))
        .toList();
    if (widget.order.paymentStatus != "Pay on delivery" || widget.order.deliveryStatus != "Pay on delivery") {
      setState(() {
        isLoading = true;
      });
      if (widget.order.paymentStatus != "Pay on delivery") {
        await checkStatus(widget.order.invoice_id);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState () {
    super.initState();
    init();
  }

}

class OrderItem extends StatefulWidget {

  int id;
  OrderItem({
    this.id
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  Item item;
  var db_helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Image.network(item.image, width: 25, height: 20,),
          Container(width: 10,),
          Text(item.itemName, style: TextStyle(
            color: Colors.black,
            fontFamily: 'inter-medium',
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),),
        ],
      ),
    );
  }

  Future<void> init () async {
    item = await db_helper.getItemByID(widget.id);
    setState(() {

    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

}

