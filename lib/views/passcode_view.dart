import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PasscodeView extends StatefulWidget {

  @override
  State<PasscodeView> createState() => _PasscodeViewState();

}

class _PasscodeViewState extends State<PasscodeView> {

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PasscodeScreen(
        title: Text("Enter passcode", style: TextStyle(
          color: Colors.white,
          fontFamily: 'inter-medium',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),),
        passwordEnteredCallback: _onPasscodeEntered,
        cancelButton: Text('Cancel'),
        deleteButton: Text('Delete'),
        shouldTriggerVerification: _verificationNotifier.stream,
      )
    );
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

}
