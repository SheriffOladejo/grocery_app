import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/models/order_detail.dart';
import 'package:grocery_app/utils/constants.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/mpesa_payment.dart';
import 'package:grocery_app/views/order_placed.dart';
import 'package:grocery_app/views/select_location.dart';

class CheckoutScreen extends StatefulWidget {

  int itemCount;
  double totalPrice;
  double orderTotal;

  CheckoutScreen({this.itemCount, this.orderTotal, this.totalPrice});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();

}

class _CheckoutScreenState extends State<CheckoutScreen> {

  var addressController = TextEditingController();

  double lat, lng;

  String selectedOption;

  double delivery = Constants.DELIVERY_PRICE;

  var db_helper = DbHelper();
  AppUser user;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.70,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15),)
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Order summary", style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-bold',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),),
            Container(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected items (${widget.itemCount})",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-medium',
                  ),
                ),
                Text(
                  "${Constants.CURRENCY}${widget.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-medium',
                  ),
                )
              ],
            ),
            Container(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-medium',
                  ),
                ),
                Text(
                  "${Constants.CURRENCY}${delivery.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-medium',
                  ),
                )
              ],
            ),
            Container(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order total",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-bold',
                  ),
                ),
                Text(
                  "${Constants.CURRENCY}${widget.orderTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-bold',
                  ),
                )
              ],
            ),
            Container(height: 8,),
            Row(
              children: [
                Image.asset("assets/images/home_location.png"),
                Container(width: 10,),
                Text("Delivery address", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'inter-bold',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    var address = await Navigator.push(context, slideLeft(SelectLocation(lat: lat, lng: lng,)));
                    addressController.text = address;
                    setState(() {

                    });
                  },
                  child: Text(
                    "Edit address",
                    style: TextStyle(
                      color: HexColor("#66906A"),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'inter-bold',
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 10,),
            Container(
              height: 70,
              child: TextFormField(
                readOnly: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                controller: addressController,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'inter-regular',
                  fontSize: 14,
                ),
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Delivery address",
                  hintStyle: TextStyle(
                    color: HexColor("#1B1C1E66"),
                    fontFamily: 'inter-regular',
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.only(left: 15),
                  enabledBorder: enabledBorder(),
                  //disabledBorder: disabledBorder(),
                  //errorBorder: errorBorder(),
                  focusedBorder: focusedBorder(),
                ),
              ),
            ),
            Container(height: 10,),
            Text("Select payment", style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-bold',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),),
            Container(height: 10,),
            RadioListTile(
              value: "payment_on_delivery",
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              title: Text("Payment on delivery", style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-medium',
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),),
              subtitle: Text(
                "With cash or bank transfer",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'inter-medium',
                ),
              ),
            ),
            RadioListTile(
                value: "payment_with_card",
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
                title: Text("Pay with MPesa", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'inter-medium',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),),
            ),
            Container(height: 15,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: MaterialButton(
                onPressed: () async {
                  if (selectedOption == "payment_with_card") {
                    await Navigator.of(context).push(slideLeft(MPesaPayment(orderTotal: widget.orderTotal, totalItemsCost: widget.totalPrice,)));
                    await sendNotification();
                    Navigator.pop(context);
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return OrderPlacedScreen();
                        }
                    );
                  }
                  else {
                    showToast("Please wait while we confirm your order");
                    await confirmOrder();
                    await sendNotification();
                    await updateStockCount();
                    Navigator.pop(context);
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return OrderPlacedScreen();
                        }
                    );
                  }

                },
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                color: HexColor("#66906A"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // <-- Radius
                ),
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Checkout",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'inter-regular'
                      ),
                    ),
                    Container(width: 5,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateStockCount () async {
    List<Item> cartList = await db_helper.getCart();

    for (var i = 0; i < cartList.length; i++) {
      int itemID = cartList[i].id;
      Item item = await db_helper.getFirebaseItemByID(itemID);
      int stockLeft = item.stockCount - cartList[i].buyingCount;
      final params = {
        "stockCount": stockLeft
      };
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("data/items/$itemID");
      await ref.update(params);
    }
  }

  Future<void> confirmOrder () async {
    String orderID = DateTime.now().millisecondsSinceEpoch.toString();
    String invoiceID = DateTime.now().millisecondsSinceEpoch.toString();
    String status = "Pay on delivery";
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    user = await db_helper.getUser();
    String ownerID = user.userID;
    List<Item> cart = await db_helper.getCart();
    String items = '';
    var itemIDs = [];
    for (var i = 0; i < cart.length; i++) {
      itemIDs.add(cart[i].id);
    }
    items = itemIDs.toString();

    var order = OrderDetail(
        orderID: orderID,
        timestamp: timestamp,
        invoice_id: invoiceID,
        deliveryPrice: Constants.DELIVERY_PRICE,
        totalItemsCost: widget.orderTotal,
        orderTotal: widget.orderTotal,
        ownerID: ownerID,
        paymentStatus: status,
        deliveryStatus: "Pending",
        desc: "",
        selectedItems: items
    );

    await db_helper.saveOrder(order, false, false);
  }

  Future<void> sendNotificationToToken(String fcmToken) async {
    // Replace YOUR_SERVER_KEY with your Firebase Server Key from Firebase Console
    final String serverKey = "AAAAMuXbrLo:APA91bHCih8jQi9cVDPs6othxRLkB2kII3V9CbqzJeMYaqcNoE6tekWXPwRUd8V6RYmlD9K4UtX5qoyTJkAI80EeFA0AK2FUKjHC6loBJOAIVOsBGcpbIoSE4Uh4p0-eAMMM1xfmGgEU";

    // Define the FCM API endpoint
    final String fcmEndpoint = "https://fcm.googleapis.com/fcm/send";

    // Define the notification payload
    final Map<String, dynamic> notification = {
      "title": "New order placed",
      "body": "You have a new order from ${user.phoneNumber}, check app for more details",
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

  Future<void> init () async {
    user = await db_helper.getUser();
    addressController.text = user.deliveryAddress;
    if (user.deliveryAddress.toLowerCase().contains("Lucky Summer".toLowerCase())) {
      delivery = 0;
    }
    setState(() {

    });
  }

  @override
  void initState () {
    super.initState();
    init();
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}
