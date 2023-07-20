import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/models/order_detail.dart';
import 'package:grocery_app/utils/constants.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:http/http.dart' as http;

class MPesaPayment extends StatefulWidget {

  double orderTotal;
  double totalItemsCost;

  MPesaPayment({
    this.orderTotal,
    this.totalItemsCost,
  });

  @override
  State<MPesaPayment> createState() => _MPesaPaymentState();

}

class _MPesaPaymentState extends State<MPesaPayment> {

  var db_helper = DbHelper();
  AppUser user;

  final form_key = GlobalKey<FormState>();
  bool is_loading = false;

  var phone_controller = TextEditingController();
  var wallet_controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_outlined, color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: form_key,
          child: Container(
            margin: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: is_loading ? Center(child: CircularProgressIndicator(),) : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty && value.substring(0, 1) == "+") {
                        return "Remove + sign";
                      }
                      else if (value.length < 10) {
                        return "Invalid number";
                      }
                      return null;
                    },
                    controller: phone_controller,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'inter-regular',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "254",
                      hintStyle: TextStyle(
                        color: HexColor("#1B1C1E66"),
                        fontFamily: 'inter-regular',
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        "MPesa Mobile number",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'inter-regular',
                          fontSize: 14,
                        ),
                      ),
                      enabledBorder: enabledBorder(),
                      disabledBorder: disabledBorder(),
                      //errorBorder: errorBorder(),
                      focusedBorder: focusedBorder(),
                    ),
                  ),
                ),
                Container(height: 10,),
                Container(
                  height: 40,
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    controller: wallet_controller,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'inter-regular',
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: "MPesa Wallet ID",
                      hintStyle: TextStyle(
                        color: HexColor("#1B1C1E66"),
                        fontFamily: 'inter-regular',
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        "MPesa Wallet ID",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'inter-regular',
                          fontSize: 14,
                        ),
                      ),
                      enabledBorder: enabledBorder(),
                      //disabledBorder: disabledBorder(),
                      //errorBorder: errorBorder(),
                      focusedBorder: focusedBorder(),
                    ),
                  ),
                ),
                Container(height: 15,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: MaterialButton(
                    onPressed: () async {
                      if (form_key.currentState.validate()) {
                        await pay();
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
                          "Continue",
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
                Container(height: 15,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pay () async {
    setState(() {
      is_loading = true;
    });
    String wallet_id = wallet_controller.text.trim();
    String phone_number = phone_controller.text.trim();

    final params = {
      "amount": widget.orderTotal.toString(),
      "phone_number": phone_number,
      "wallet_id": wallet_id,
    };

    var url = Uri.parse('https://payment.intasend.com/api/v1/payment/mpesa-stk-push/');

    var headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer ISSecretKey_live_8ff0aabc-17a6-44d1-a2a5-339c5fc8947d',
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body.toString());
        String orderID = data["id"];
        String invoiceID = data["invoice"]["invoice_id"];
        String status = data["invoice"]["state"];
        print("response: " + response.body.toString());
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
          totalItemsCost: widget.totalItemsCost,
          orderTotal: widget.orderTotal,
          ownerID: ownerID,
          paymentStatus: status,
          desc: "",
          selectedItems: items
        );

        await db_helper.saveOrder(order, false, false);
        await checkStatus(invoiceID);

      } else {
        // Request failed
        print('Error posting data: ${response.body.toString()}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }

    setState(() {
      is_loading = false;
    });

  }

  Future<void> checkStatus (String invoice_id) async {
    final params = {
      "invoice_id": invoice_id,
    };

    var url = Uri.parse('https://payment.intasend.com/api/v1/payment/status/');

    var headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer ISSecretKey_live_8ff0aabc-17a6-44d1-a2a5-339c5fc8947d',
    };

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(params),
      );

      if (response.statusCode == 200) {
        print("payment status response: ${response.body.toString()}");
        Map<String, dynamic> data = jsonDecode(response.body.toString());
        String invoiceID = data["invoice"]["invoice_id"];
        String status = data["invoice"]["state"];
        if (status == 'SUCCESS') {
          await db_helper.updateOrderStatus(invoiceID, status, "Confirmed");
        }


      } else {
        // Request failed
        print('Error posting data: ${response.body.toString()}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }

  }

}
