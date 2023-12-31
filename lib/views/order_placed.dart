import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/splash_screen.dart';

class OrderPlacedScreen extends StatefulWidget {

  const OrderPlacedScreen({Key key}) : super(key: key);

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();

}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {

  DbHelper db_helper = DbHelper();
  AppUser user;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.70,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/images/pana.png"),
              Container(height: 40,),
              Text("Your order has been placed", style: TextStyle(
                color: Colors.black,
                fontFamily: 'inter-bold',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),),
              Container(height: 80,),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: MaterialButton(
                  onPressed: () {
                    int count = 0;
                    Navigator.of(context).popUntil((_) => count++ >= 2);
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
                        "Continue shopping",
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
      ),
    );
  }

  Future<void> init () async {
    List<Item> cart = await db_helper.getCart();
    user = await db_helper.getUser();
    for (var i = 0; i < cart.length; i++) {
      await db_helper.deleteCart(cart[i].id, user.phoneNumber);
    }
  }

  @override
  void initState () {
    super.initState();
    init();
  }

}
