import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mistry_customer/screens/auth/landing_screen.dart';
import 'package:mistry_customer/screens/auth/sign_in_screen.dart';

import '../../services/shared_service.dart';
import '../../utils/config.dart';
import '../dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String routeName = 'SplashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          alignment: Alignment.center,
          matchTextDirection: true,
          repeat: ImageRepeat.noRepeat,
          image: AssetImage("assets/images/splash_light_background.png"),
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(
                //   color: primaryColor,
                //   width: 3.0,
                // ),
              ),
              child: ClipOval(
                child: Image(
                  image: AssetImage("assets/icons/ic_logo.png"),
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            Text(
              "Wow Service",
              style: TextStyle(
                  fontFamily: "Work Sans",
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> whereToGo() async {
    var isLoggedIn = await SharedService.isLoggedIn();
    // var isLoggedIn = false;

    // Timer(Duration(seconds: 3),(){
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => DashboadScreen(currentIndex: 0),
    //       ));
    // });

    Timer(Duration(seconds: 3), () {
      print(isLoggedIn);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboadScreen(currentIndex: 0),
          ));
      // if (isLoggedIn != null) {
      //   if (isLoggedIn) {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => DashboadScreen(currentIndex: 0),
      //         ));
      //   } else {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => LandingScreen(),
      //         ));
      //   }
      // } else {
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => DashboadScreen(currentIndex: 0),
      //       ));
      // }
    });
  }
}
