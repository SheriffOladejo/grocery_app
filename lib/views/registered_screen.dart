import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/utils/hex_color.dart';
import 'package:grocery_app/utils/methods.dart';
import 'package:grocery_app/views/otp_verification.dart';
import 'package:grocery_app/views/select_location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RegisteredScreen extends StatefulWidget {

  const RegisteredScreen({Key key}) : super(key: key);

  @override
  State<RegisteredScreen> createState() => _RegisteredScreenState();

}

class _RegisteredScreenState extends State<RegisteredScreen> {


  double lat, lng;

  var phone_controller = TextEditingController();
  var email_controller = TextEditingController();
  var address_controller = TextEditingController();

  final form_key = GlobalKey<FormState>();

  bool is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                Image.asset("assets/images/register.png", width: 410, height: 305,),
                Container(height: 15,),
                Text("Search and order your groceries online", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'inter-bold',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,),
                Container(height: 15,),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isNotEmpty && value.substring(0, 1) != "+") {
                        return "Country code required";
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
                      hintText: "+234",
                      hintStyle: TextStyle(
                        color: HexColor("#1B1C1E66"),
                        fontFamily: 'inter-regular',
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        "Mobile number",
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
                    validator: (value) {
                      final bool isValid = EmailValidator.validate(email_controller.text.trim());
                      if (!isValid) {
                        return "Invalid email";
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    controller: email_controller,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'inter-regular',
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: HexColor("#1B1C1E66"),
                        fontFamily: 'inter-regular',
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        "Email",
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
                Container(height: 10,),
                Container(
                  height: 70,
                  child: TextFormField(
                    onTap: () async {
                      var address = await Navigator.push(context, slideLeft(SelectLocation(lat: lat, lng: lng,)));
                      address_controller.text = address;
                      setState(() {

                      });
                    },
                    readOnly: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    controller: address_controller,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'inter-regular',
                      fontSize: 14,
                    ),
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Delivery address",
                      hintStyle: TextStyle(
                        color: HexColor("#1B1C1E66"),
                        fontFamily: 'inter-regular',
                        fontSize: 14,
                      ),
                      contentPadding: EdgeInsets.only(left: 15),
                      label: Text(
                        "Delivery address",
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
                    onPressed: () {
                      if (form_key.currentState.validate()) {
                        Navigator.of(context).push(slideLeft(PhoneVerification(phoneNumber: phone_controller.text.trim(),)));
                    }},
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Before using this app, you can review our",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'solata-regular',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var url = "";
                        if(await canLaunch(url)){
                          await launch(url);
                        }
                        else{
                          showToast("Cannot launch URL");
                        }
                      },
                      child: const Text(
                        "privacy policy ",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'solata-regular',
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Text(
                      "and ",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'solata-regular',
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var url = "";
                        if(await canLaunch(url)){
                          await launch(url);
                        }
                        else{
                          showToast("Cannot launch URL");
                        }
                      },
                      child: const Text(
                        "terms of use. ",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'solata-regular',
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    setState(() {
      is_loading = true;
    });
    var pos = await getPosition();
    lat = pos.latitude;
    lng = pos.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

    var address = "${placemarks[0].street}, ${placemarks[0].subAdministrativeArea}, "
        "${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}, "
        "${placemarks[0].postalCode}";

    address_controller.text = address;
    phone_controller.text = "+2347019240234";
    email_controller.text = "sherifffoladejo@gmail.com";
    setState(() {
      is_loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

}
