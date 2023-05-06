import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/square_tile.dart';
import 'package:mistry_customer/model/user_model.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/auth/verify_otp_screen.dart';
import 'package:mistry_customer/services/auth_service.dart';
import 'package:mistry_customer/utils/ProgressHUG.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

import 'package:snippet_coder_utils/FormHelper.dart';

import '../dashboard_screen.dart';

class LandingScreen extends ConsumerStatefulWidget {
  final bool? isFromDashboard;
  LandingScreen({this.isFromDashboard});
  @override
  ConsumerState<LandingScreen> createState() => _SignInState();
}

class _SignInState extends ConsumerState<LandingScreen> {
  //validate our form now
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  UserModel loginRequestModel = new UserModel();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  bool isAPICallProcess = false;
  bool isSendOtp = true;
  @override
  void initState() {
    super.initState();
    countryController.text = "+91";
    phoneNoController.addListener(() {
      isSendOtp = phoneNoController.text.isNotEmpty;
      setState(() {
        this.isSendOtp = isSendOtp;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>DashboadScreen(currentIndex: 0),
                ),
              );
              // Navigator.of(context, rootNavigator: true).pop(context);
            },
          ),

          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: "Work Sans",
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(left: 25, right: 25),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hello!",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Work Sans",
                        fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Back, you\'ve been missed",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Work Sans",
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF0F0FA),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // Background color
                      ),
                      onPressed: () async {

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/sigin',
                          (route) => true,
                        );

                      },
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ImageIcon(AssetImage(calling)),
                            Container(
                              margin: EdgeInsets.only(right: 80),
                              child: Text(
                                "Sign in with OTP",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Work Sans",
                              fontSize: 14),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Color(0Xff5F60B9),
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Work Sans",
                                fontSize: 14),
                          ),
                          onTap: () {

                            Navigator.pushNamedAndRemoveUntil(
                                context, ("/register"), (route) => false);
                            // Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // or continue with
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.grey[400],
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //         child: Text(
                  //           'Or continue with',
                  //           style: TextStyle(color: Colors.grey[700],fontFamily: 'Work Sans'),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.grey[400],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
