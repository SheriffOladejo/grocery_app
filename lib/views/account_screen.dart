import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/add_item.dart';
import 'package:grocery_app/views/order_history.dart';
import 'package:grocery_app/views/stock_management_screen.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class AccountScreen extends StatefulWidget {

  const AccountScreen({Key key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();

}

class _AccountScreenState extends State<AccountScreen> {

  AppUser user;
  var db_helper = DbHelper();

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Welcome Admin", style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontFamily: 'inter-bold',
              fontSize: 16,
            ),),
            Container(height: 5,),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(height: 25,),
            InkWell(
              onTap: () {
                Navigator.push(context, slideLeft(OrderHistory()));
              },
              child: Row(
                children: [
                  Image.asset("assets/images/order_history.png"),
                  Container(width: 15,),
                  Text("Order history", style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter-medium',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
                  Spacer(),
                  Icon(Icons.chevron_right, size: 24, color: Colors.black,),
                ],
              ),
            ),
            Container(height: 12.5,),
            Divider(),
            Container(height: 12.5,),
            InkWell(
              onTap: () {
                Navigator.push(context, slideLeft(StockManagementScreen()));
              },
              child: Row(
                children: [
                  Image.asset("assets/images/stock_management.png"),
                  Container(width: 15,),
                  Text("Stock management", style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'inter-medium',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),),
                  Spacer(),
                  Icon(Icons.chevron_right, size: 24, color: Colors.black,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> init () async {
    _showLockScreen(context);
    user = await db_helper.getUser();
    setState(() {

    });
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '070192' == enteredPasscode;
    _verificationNotifier.add(isValid);
  }

  _showLockScreen(
      BuildContext context, {
        bool opaque,
        CircleUIConfig circleUIConfig,
        KeyboardUIConfig keyboardUIConfig,
        Widget cancelButton,
        List<String> digits,
      }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
                title: Text(
                  'Enter App Passcode',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                circleUIConfig: circleUIConfig,
                keyboardUIConfig: keyboardUIConfig,
                passwordEnteredCallback: _onPasscodeEntered,
                cancelButton: cancelButton,
                deleteButton: Text(
                  'Delete',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  semanticsLabel: 'Delete',
                ),
                shouldTriggerVerification: _verificationNotifier.stream,
                backgroundColor: Colors.black.withOpacity(0.8),
                cancelCallback: _onPasscodeCancelled,
                digits: digits,
                passwordDigits: 6,
              ),
        ));
  }

  _onPasscodeCancelled() {

  }

  @override
  void initState() {
    super.initState();
    init();
  }

}
