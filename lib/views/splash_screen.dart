import 'package:flutter/material.dart';
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

  void init() async {
    var user = await db_helper.getUser();
    if (user == null) {
      await Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, slideLeft(const RegisteredScreen()));
      });
    }
    else {
      await Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, slideLeft(const BottomNav()));
      });
    }

  }

  @override
  void initState() {
    super.initState();
    init();
  }

}
