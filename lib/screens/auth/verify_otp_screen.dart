import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/model/user_model.dart';
import 'package:mistry_customer/provider/data_provider.dart';

import 'package:mistry_customer/services/auth_service.dart';
import 'package:mistry_customer/utils/ProgressHUG.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class VerifyOtp extends ConsumerStatefulWidget {
  String? phoneNo;

  VerifyOtp({this.phoneNo});

  @override
  ConsumerState<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends ConsumerState<VerifyOtp> {
  //validate our form now
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  UserModel loginRequestModel = UserModel();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  bool isApiCallProcess = false;
  String? otpCode = "";
  String? phoneNo;
  @override
  void initState() {
    super.initState();
    phoneNo = widget.phoneNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,

      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
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
                  "OTP VERIFICATION",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Work Sans",
                      fontSize: 22),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter the OTP sent to ${phoneNo}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Work Sans",
                      fontSize: 16),
                ),

                SizedBox(
                  height: 30,
                ),

                // Container(
                //   padding: EdgeInsets.all(28),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //
                //           _textFieldOTP(first: true, last: false),
                //           _textFieldOTP(first: false, last: false),
                //           _textFieldOTP(first: false, last: false),
                //           _textFieldOTP(first: false, last: true),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 22,
                //       ),
                //
                //     ],
                //   ),
                // ),

                otpField(),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0Xff5F60B9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      // Background color
                    ),
                    onPressed: () async {
                      loginRequestModel.otp = otpCode;
                      loginRequestModel.phoneNo =
                          countryController.text + phoneNoController.text;
                      print(otpCode);
                      print(loginRequestModel.toJson());
                      if (validateAndSave()) {
                        loginRequestModel.otp = otpCode;
                        loginRequestModel.phoneNo = phoneNo;
                        setState(() {
                          isApiCallProcess = true;
                        });

                        try {
                          var response = await ref
                              .read(authOtpProvider)
                              .verifyOtpCode(loginRequestModel);
                          if (response.message !=
                              "Otp is either expired or incorrect" ||
                              response.message !=
                                  "Incorrect username or password") {
                            Navigator.pushNamedAndRemoveUntil(
                                context, ("/dashboard"), (route) => false);
                          } else {
                            FormHelper.showSimpleAlertDialog(
                              context,
                              Config.appName,
                              "Something went wrong !!",
                              "OK",
                                  () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        }catch(e){
                          FormHelper.showSimpleAlertDialog(
                            context,
                            Config.appName,
                            "User is not found in our database",
                            "OK",
                                () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, ("/sigin"), (route) => false);
                            },
                          );
                        }
                        setState(() {
                          isApiCallProcess = false;
                        });

                      }
                    },
                    child:  isApiCallProcess
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
                        : const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Didn't you receive any code?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 18,
                ),
                InkWell(
                  onTap: () async {
                    var response =
                        await ref.read(authOtpProvider).requestOtp(phoneNo!);
                    if (response.status != "failed") {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "New Otp has been sent",
                        "OK",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                  child: Text(
                    "Resend New Code",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    return Container(
      height: 90,
      child: AspectRatio(
        aspectRatio: 0.7,
        child: TextFormField(
          autofocus: true,
          onSaved: (pin) {
            otpCode = otpCode! + pin.toString();
          },
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // otpCode=value.toString();
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(12)),
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

  Widget otpField() {
    return OTPTextField(
      length: 4,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 58,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Color(0xffEBEBEB),
        borderColor: Colors.white,
      ),
      style: TextStyle(fontSize: 17, color: Colors.black),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          otpCode = pin;
        });
      },
    );
  }
}
