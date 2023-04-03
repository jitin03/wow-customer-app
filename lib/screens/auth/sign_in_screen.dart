import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/square_tile.dart';
import 'package:mistry_customer/model/user_model.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/screens/auth/verify_otp_screen.dart';
import 'package:mistry_customer/services/auth_service.dart';
import 'package:mistry_customer/utils/ProgressHUG.dart';
import 'package:mistry_customer/utils/config.dart';

import 'package:snippet_coder_utils/FormHelper.dart';

class SignIn extends ConsumerStatefulWidget {
  final bool? isFromDashboard;
  SignIn({this.isFromDashboard});
  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  //validate our form now
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  UserModel loginRequestModel = new UserModel();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  bool isApiCallProcess = false;
  bool isSendOtp = false;
  @override
  void initState() {
    super.initState();
    countryController.text = "+91";
    phoneNoController.addListener(() {
      isSendOtp = phoneNoController.text.isNotEmpty;
      setState(() {
        this.isSendOtp = isSendOtp;
        this.isApiCallProcess = false;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (widget.isFromDashboard == true) {
    } else {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please enter your valid registered phone no.",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Work Sans",
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 40,
                          child: TextFormField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(fontSize: 33, color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: phoneNoController,
                            keyboardType: TextInputType.phone,
                            // validator: (value){
                            //   if(value!.isEmpty || value ==null){
                            //
                            //     return 'Please enter the registered phone no.';
                            //   }
                            // },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              hintText: "Phone",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0Xff5F60B9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        // Background color
                      ),
                      onPressed: isSendOtp == false
                          ? null
                          : () async {
                              if (validateAndSave()) {
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return VerifyOtp(
                                      phoneNo: countryController.text +
                                          phoneNoController.text);
                                }));

                                await ref.read(authOtpProvider).requestOtp(
                                    countryController.text +
                                        phoneNoController.text);

                                setState(() {
                                  isApiCallProcess = false;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please enter the correct  registered phone number')),
                                );
                              }
                            },
                      child: isApiCallProcess
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontFamily: 'Work Sans',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              ],
                            )
                          : Text(
                              "SEND OTP",
                              style: TextStyle(color: Colors.white),
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
