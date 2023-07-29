import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/item.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/bottom_nav.dart';
import 'package:grocery_app/views/registered_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  var db_helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#66906A"),
      appBar: AppBar(
        backgroundColor: HexColor("#66906A"),
        elevation: 0,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset("assets/images/splash_screen.png", width: 165, height: 165,),
        ),
      ),
    );
  }

  Future<void> getNewItems () async {
    List<Item> items = await db_helper.getItems();
    int last_id = 0;
    if (items.isNotEmpty) {
      last_id = items[items.length - 1].id;
    }
    final snapshot = await FirebaseDatabase.instance.ref().child('data/items/').get();
    final list = snapshot.children;
    list.forEach((element) async {
      var i = Item(
        id: int.parse(element.child("id").value.toString()),
        stockCount: element.child("stockCount").value,
        itemName: element.child("itemName").value,
        description: element.child("description").value,
        category: element.child("category").value,
        image: element.child("image").value,
        isBuyingWholesale: element.child("isBuyingWholesale").value,
        wholesaleImage: element.child("image").value,
        favorite: element.child("favorite").value,
        wholesalePrice: double.parse(element.child("wholesalePrice").value.toString()),
        wholesaleUnit: element.child("wholesaleUnit").value,
        buyingCount: element.child("buyingCount").value,
        retailPrice: double.parse(element.child("retailPrice").value.toString()),
        discount: double.parse(element.child("discount").value.toString()),
      );
      if (i.id > last_id) {
        await db_helper.saveItem(i);
      }
    });
  }

  void init() async {
    var user = await db_helper.getUser();
    await getNewItems();
    if (user == null) {
      await Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, slideLeft(const RegisteredScreen()));
      });
    }
    else {
      Navigator.pushReplacement(context, slideLeft(const BottomNav()));
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

}
