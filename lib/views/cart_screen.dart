import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_app/adapters/cart_adapter.dart';
import 'package:grocery_app/adapters/item_adapter.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              //showWholesalePrice: cartList[index].isBuyingWholesale == "true",
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
                  "\$${totalItemsPrice.toStringAsFixed(2)}",
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
                  "\$${deliveryPrice.toStringAsFixed(2)}",
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
                  "\$${orderTotal.toStringAsFixed(2)}",
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
                      return CheckoutScreen(totalPrice: 120, orderTotal: 230, itemCount: 10,);
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

  Future<void> init() async {
    for (var i = 0; i < 12; i++) {
      cartList.add(Item(
        itemName: "Lettuce plant",
        stockCount: 15,
        category: "Vegetables",
        image: "assets/images/lettuce.png",
        wholesaleImage: "assets/images/lettuce.png",
        discount: 10.0,
        wholesalePrice: 750.0,
        isBuyingWholesale: "true",
        buyingCount: 3,
        wholesaleUnit: 5,
        retailPrice: 200.0,
        favorite: "true",
      ));
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
