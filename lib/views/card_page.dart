import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:grocery_app/models/app_user.dart';
import 'package:grocery_app/utils/constants.dart';
import 'package:grocery_app/utils/db_helper.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:http/http.dart' as http;
import 'package:grocery_app/views/splash_screen.dart';

class CardPage extends StatefulWidget {

  double orderTotal;
  CardPage({this.orderTotal});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {

  String cardNumber = '';
  String expiryDate = '';
  String expiryMonth = '';
  String expiryYear = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AppUser user;
  DbHelper db_helper = DbHelper();

  bool is_loading = false;

  Future<void> attachPaymentMethod(String paymentMethodId, String customerId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${Constants.stripe_secret_key}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    print("card_page.attachPaymentMethod customer id: $customerId");
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      print("card_page.attachPaymentMethod response: ${response.body.toString()}");
    } else {
      print("card_page.attachPaymentMethod: an error occurred: ${response.body.toString()}");
    }
  }

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
        title: Text("", style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'inter-bold',
        ),),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: is_loading ? loadingPage() : mainPage(),
    );
  }

  Future<String> createPaymentMethod() async {
    String payment_method_id = "";
    List<String> dates = expiryDate.split("/");
    var expiryMonth = dates[0];
    var expiryYear = dates[1];
    final params = {
      'type': 'card',
      'card[number]': cardNumber,
      'card[exp_month]': expiryMonth,
      'card[exp_year]': expiryYear,
      'card[cvc]': cvvCode,
    };
    Map<String, String> headers = {
      'Authorization': 'Bearer ${Constants.stripe_secret_key}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: params,
    );
    if (response.statusCode == 200) {
      if(response.body != ""){
        var json = jsonDecode(response.body.toString());
        payment_method_id = json["id"];
      }
    }
    else {
      print("card_page.createPaymentMethod an error occurred: ${response.body.toString()}");
    }
    return payment_method_id;
  }

  Future<void> init() async {
    setState(() {
      is_loading = true;
    });
    user = await db_helper.getUser();
    setState(() {
      is_loading = false;
    });
  }

  @override
  void initState(){
    init();
    super.initState();
  }

  Widget mainPage(){
    return  SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CreditCardWidget(
                cardBgColor: Colors.redAccent[200],
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                onCreditCardWidgetChange: (CreditCardBrand card) {
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CreditCardForm(
                        formKey: formKey,
                        onCreditCardModelChange: onCreditCardModelChange,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expiry date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder Name',
                        ),
                        cvvCode: cvvCode,
                        cardHolderName: cardHolderName,
                        themeColor: Colors.white,
                        expiryDate: expiryDate,
                        cardNumber: cardNumber,
                      ),
                      SizedBox(height: 8,),
                      Text("Your card details will not be saved for later use",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'inter-medium',
                          )),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Text(
                            'Pay ${Constants.CURRENCY}${widget.orderTotal.toStringAsFixed(1)} with card',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff1b447b),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            setState(() {
                              is_loading = true;
                            });
                            String payment_method_id = await createPaymentMethod();
                            await attachPaymentMethod(payment_method_id, user.stripeID);
                            await updateCustomer(payment_method_id, user.stripeID);
                            await createPaymentIntent(user.stripeID, payment_method_id);
                            setState(() {
                              is_loading = false;
                            });
                          } else {

                          }
                        },
                      )
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

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<void> confirmPaymentIntent(String id) async {
    final String url = 'https://api.stripe.com/v1/payment_intents/$id/confirm';
    Map<String, String> headers = {
      'Authorization': 'Bearer ${Constants.stripe_secret_key}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {},
    );
    if (response.statusCode == 200) {
      if(response.body != ""){
        var json = jsonDecode(response.body.toString());
        String status = json["status"];
        if (status == "succeeded") {
          showToast("Your payment was successful!");
        }
        else {
          showToast("Your payment was not successful!");
          setState(() {
            is_loading = false;
          });
        }
      }
    } else {
      print("card_page.payWithStripe: an error occurred: ${response.body.toString()}");
    }
  }

  Future<void> createPaymentIntent(String customer_id, String payment_method_id) async {
    String _amount = (widget.orderTotal * 100).toStringAsFixed(0);
    int amount = int.parse(_amount);
    final String url = 'https://api.stripe.com/v1/payment_intents';
    Map<String, String> headers = {
      'Authorization': 'Bearer ${Constants.stripe_secret_key}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'customer': customer_id,
        'amount': '$amount',
        'currency': Constants.CURRENCY_NAME,
        'payment_method': payment_method_id
      },
    );
    if (response.statusCode == 200) {
      if(response.body != ""){
        var json = jsonDecode(response.body.toString());
        String id = json["id"];
        await confirmPaymentIntent(id);
      }
    } else {
      print("card_page.payWithStripe: an error occurred: ${response.body.toString()}");
    }
  }

  Future<void> updateCustomer(String payment_method_id, String customer_id) async {
    final String url = 'https://api.stripe.com/v1/customers/$customer_id';
    Map<String, String> headers = {
      'Authorization': 'Bearer ${Constants.stripe_secret_key}',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'invoice_settings[default_payment_method]': payment_method_id,
      },
    );
    if (response.statusCode == 200) {
    } else {
      print("card_page.updateCustomer: an error occurred: ${response.body.toString()}");
    }
  }

}