import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/cart_adapter.dart';
import 'package:grocery_app/adapters/item_adapter.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/constants.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/views/checkout.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({Key key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();

}

class _CartScreenState extends State<CartScreen> {

  List<Item> cartList = [];
  double totalItemsPrice = 0;

  double orderTotal = 0;

  // Set delivery price here
  double deliveryPrice = Constants.DELIVERY_PRICE;

  var db_helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("My cart", style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'inter-bold',
        ),),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: cartList.length,
          shrinkWrap: true,
          controller: ScrollController(),
          itemBuilder: (context, index) {
            return CartAdapter(
              item: cartList[index],
              callback: callback,
            );
          },
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        padding: const EdgeInsets.all(15),
        child: Column(
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
                  "Selected items (${cartList.length})",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-medium',
                  ),
                ),
                Text(
                  "${Constants.CURRENCY}${totalItemsPrice.toStringAsFixed(2)}",
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
                  "${Constants.CURRENCY}${deliveryPrice.toStringAsFixed(2)}",
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
                  "${Constants.CURRENCY}${orderTotal.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-bold',
                  ),
                )
              ],
            ),
            Container(height: 15,),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: MaterialButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return CheckoutScreen(totalPrice: totalItemsPrice, orderTotal: orderTotal, itemCount: cartList.length,);
                    }
                  );
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
                      "Confirm order",
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

  Future<void> callback () async {
    await init();
  }

  Future<void> init() async {
    cartList = await db_helper.getCart();
    totalItemsPrice = 0;
    orderTotal = 0;

    for (var i = 0; i < cartList.length; i++) {
      if (cartList[i].isBuyingWholesale == 'true') {
        double price = (cartList[i].buyingCount / cartList[i].wholesaleUnit) * cartList[i].wholesalePrice;
        totalItemsPrice += price;
      }
      else {
        double price = cartList[i].buyingCount * cartList[i].retailPrice;
        totalItemsPrice += price;
      }
    }

    orderTotal = totalItemsPrice + deliveryPrice;

    if (cartList.isEmpty) {
      orderTotal = 0;
      totalItemsPrice = 0;
    }

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

}
