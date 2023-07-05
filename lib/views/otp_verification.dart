import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/bottom_nav.dart';
import 'package:grocery_app/views/home_screen.dart';

class PhoneVerification extends StatefulWidget {

  String phoneNumber = "";

  PhoneVerification({this.phoneNumber});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {

  String verificationId;
  int forceResendingToken;
  bool isLoading = false;

  String otp_code = "";
  bool canResend = false;

  int secondsRemaining = 45;

  Timer timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (secondsRemaining < 1) {
          t.cancel();
          setState(() {
            canResend = true;
          });
        } else {
          secondsRemaining -= 1;
        }
      });
    });
  }

  String formatDuration(int second) {
    Duration duration = Duration(seconds: second);
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 15,),
            Text("OTP Verification", style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-bold',
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),),
            Container(height: 20,),
            Text("An OTP has been sent to ${widget.phoneNumber}", style: TextStyle(
              color: Colors.black,
              fontFamily: 'inter-medium',
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),),
            Container(height: 30,),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                if (code.length == 6) {
                  //otp_code = code;
                  //_verifyCode();
                }
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode){
                setState(() {
                  otp_code = verificationCode;
                  _verifyCode();
                });
              }, // end onSubmit
            ),
            Container(height: 20,),
            InkWell(
              onTap: () async {
                if (canResend) {
                  await init();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset("assets/images/message.png", color: canResend ? HexColor("#66906A") : Colors.grey),
                  Container(width: 5,),
                  Text("Resend OTP", style: TextStyle(
                      color: canResend ? HexColor("#66906A") : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'inter-medium',
                      fontSize: 12,
                  ),),
                  Container(width: 10,),
                  Text("${formatDuration(secondsRemaining)}", style: TextStyle(
                    color: canResend ? HexColor("#66906A") : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'inter-medium',
                    fontSize: 12,
                  ),),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: isLoading ? Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: Alignment.center,
        color: Colors.white,
        child: CircularProgressIndicator(),
      ) : Container(width: 0, height: 0,),
    );
  }

  Future<void> _submitPhoneNumber() async {
    setState(() {
      isLoading = true;
    });

    showToast("Sending OTP, please wait");
    try {
      await verifyPhoneNumber(
        widget.phoneNumber,
            (credential) async {
          setState(() {
            isLoading = false;
          });
          await signInWithCredential(credential);
        },
            (message) {
          showToast("Verification failed: $message");
          print("Verification failed: $message");
          Navigator.pop(context);
        },
            (verificationId, forceResendingToken) {
          showToast("A verification code has been sent to you");
          startTimer();
          setState(() {
            this.verificationId = verificationId;
            this.forceResendingToken = forceResendingToken;
            isLoading = false;
          });
        },
            (verificationId) {
          //showToast("Verification timeout, try again");
          //Navigator.pop(context);
        },
      );
    } catch (e) {
      showToast("An error occurred");
      print("_submitPhoneNumber error: ${e.toString()}");
      Navigator.pop(context);
    }
  }

  void _verifyCode() async {
    setState(() {
      isLoading = true;
    });

    if (otp_code.length == 6) {
      try {
        AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp_code);
        await signInWithCredential(credential);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showToast('Invalid verification code. Please try again.');
        Navigator.pop(context);
      }
    }
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      // var db = DbHelper();
      // await db.savePhoneNumber(phoneNumber);
      Navigator.of(context).pushReplacement(slideLeft(const BottomNav()));
    } catch (e) {
      showToast("An error occurred, probably incorrect code");
      setState(() {
        isLoading = false;
      });
      //Navigator.pop(context);
    }
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, Function(AuthCredential) verificationCompleted,
      Function(String) verificationFailed, Function(String, int) codeSent, Function(String) codeAutoRetrievalTimeout) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    void _verificationCompleted(AuthCredential credential) {
      verificationCompleted(credential);
    }

    void _verificationFailed(FirebaseAuthException authException) {
      verificationFailed(authException.message ?? 'Verification failed');
    }

    void _codeSent(String verificationId, int forceResendingToken) {
      codeSent(verificationId, forceResendingToken);
    }

    void _codeAutoRetrievalTimeout(String verificationId) {
      codeAutoRetrievalTimeout(verificationId);
    }

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
  }

  Future<void> init () async {
    await _submitPhoneNumber();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

}
