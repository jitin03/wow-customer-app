import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/services/customer_service.dart';

import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';
import 'package:mistry_customer/model/customer_profile_response_bck.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class CustomerProfileSetup extends StatefulWidget {
  final firstname;
  final lastname;
  final email;
  final phonenumber;

  CustomerProfileSetup(
      {this.firstname, this.lastname, this.email, this.phonenumber});

  @override
  State<CustomerProfileSetup> createState() => _CustomerProfileSetupState();
}

class _CustomerProfileSetupState extends State<CustomerProfileSetup> {
  late String fullname;
  String? selectedCity = null;
  String? selectedState = null;
  String? selectedGender =null;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Address customerAddress = new Address();
  bool isApiCallProcess = false;
  CustomerProfileRequest serviceRequest = new CustomerProfileRequest();

  late String email;
  late String phonenumber;
  @override
  void initState() {
    super.initState();
    fullname = widget.firstname + " " + widget.lastname;
    email = widget.email;
    phonenumber = widget.phonenumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Please help us to create your better profile !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Work Sans",
                  fontSize: 16,
                  color: Color(0XFF6C757D),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Center(
                  child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              initialValue: fullname,
                              onSaved: (value) {
                                serviceRequest.name = value;
                              },
                              onChanged: (input) => serviceRequest.name =
                                  input == null ? email : input,
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Image.asset(profile,
                                        height: 20,
                                        width: 20,
                                        color: Color(0xFF6C757D)),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Full Name",
                                  hintText: "Full Name"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              initialValue: email,
                              onChanged: (input) {
                                serviceRequest.emailaddress =
                                    input == null ? email : input;
                              },
                              onSaved: (value) {
                                serviceRequest.emailaddress = value;
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Image.asset(ic_message,
                                        height: 20,
                                        width: 20,
                                        color: Color(0xFF6C757D)),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Email Address",
                                  labelText: "Email"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              initialValue: phonenumber,
                              onSaved: (value) {
                                serviceRequest!.phonenumber = int.parse(value!);
                              },
                              onChanged: (input) =>
                                  serviceRequest!.phonenumber = input == null
                                      ? int.parse(phonenumber)
                                      : int.parse(input),
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Image.asset(calling,
                                        height: 20,
                                        width: 20,
                                        color: Color(0xFF6C757D)),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Phone number",
                                  hintText: "Phone number"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  onChanged: (input) {
                                    serviceRequest!.age =
                                    input == null ? int.parse(" ") : int.parse(input);
                                  },
                                  onSaved: (value) {
                                    serviceRequest.age = int.parse(value!);
                                  },
                                  validator: (value){
                                    if(value!.isEmpty || value ==null){

                                      return 'Please enter the Age';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Age",
                                    isDense: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: primaryColor, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: "Gender",
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    dropdownColor: Colors.white,
                                    value: selectedGender,
                                    validator: (value){
                                      if(value!.isEmpty || value ==null){

                                        return 'Please select the gender';
                                      }
                                    },
                                    onChanged: (String? newValue) {
                                      serviceRequest.gender = newValue!;
                                      setState(() {
                                        selectedGender = newValue!;
                                      });
                                    },
                                    items: getGenderItems()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              onChanged: (input) => customerAddress.address1 = input,
                              validator: (value){
                                if(value!.isEmpty || value ==null){

                                  return 'Please enter the Address';
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Image.asset(ic_location,
                                        height: 20,
                                        width: 20,
                                        color: Color(0xFF6C757D)),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Address Line 1",
                                  hintText: "Address Line 1"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              onChanged: (input) => customerAddress!.address2 = input,
                              validator: (value){
                                if(value!.isEmpty || value ==null){

                                  return 'Please enter the Address';
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    child: Image.asset(ic_location,
                                        height: 20,
                                        width: 20,
                                        color: Color(0xFF6C757D)),
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Address Line 2",
                                  hintText: "Address Line 2"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: "City",
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    dropdownColor: Colors.white,
                                    value: selectedCity,
                                    onChanged: (String? newValue) {
                                      customerAddress.city = newValue!;
                                      setState(() {
                                        selectedCity = newValue;
                                      });
                                    },
                                    items: getdropdownItems()),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: "State",
                                      isDense: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    dropdownColor: Colors.white,
                                    value: selectedState,
                                    validator: (value){
                                      if(value!.isEmpty || value ==null){

                                        return 'Please select the State';
                                      }
                                    },
                                    onChanged: (String? newValue) {
                                      customerAddress.state = newValue!;
                                      setState(() {
                                        selectedState = newValue!;
                                      });
                                    },
                                    items: getStateItems()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              onChanged: (input) => customerAddress.pincode = input,
                              validator: (value){
                                if(value!.isEmpty || value ==null){

                                  return 'Please enter the Pincode';
                                }
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Pincode",
                                  labelText: "Pincode"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0XFFF6F7F9),
                              border: Border.all(color: Color(0XFF6F7F9)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              initialValue: "India",
                              decoration: InputDecoration(
                                  suffixIcon: Align(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Country",
                                  labelText: "Country"),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),

                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 25, right: 25),
                        padding:  EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0Xff5F60B9),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            // Background color
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {

                              if (serviceRequest.name == null ||
                                  serviceRequest.emailaddress == null ||
                                  serviceRequest.phonenumber == null) {
                                serviceRequest.name = fullname;
                                serviceRequest.phonenumber =
                                    int.parse(phonenumber);
                                serviceRequest.emailaddress = email;

                              }
                              setState(() {
                                isApiCallProcess = true;
                              });
                              serviceRequest!.address = customerAddress;


                              CustomerService.saveCustomerProfile(
                                      serviceRequest)
                                  .then((response) {
                                setState(() {
                                  isApiCallProcess = false;
                                });
                                if (response) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/sigin',
                                    (route) => false,
                                  );
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
                              });
                            }
                          },
                          child: isApiCallProcess
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Loading...",
                                style: TextStyle(
                                  fontFamily: 'Work Sans', fontSize: 16, color: Colors.white,),
                              ),
                              SizedBox(width: 10,),
                              Transform.scale(
                                scale: 0.5,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            ],
                          ) : Text(
                            "SAVE",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Work Sans"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getdropdownItems() {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Jaipur"), value: "Jaipur"),
      DropdownMenuItem(child: Text("Alwar"), value: "Alwar"),
      DropdownMenuItem(child: Text("Jodhpur"), value: "Jodhpur"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> getStateItems() {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Rajasthan"), value: "Rajasthan"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> getGenderItems() {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
      DropdownMenuItem(child: Text("Other"), value: "Other"),
    ];
    return menuItems;
  }
}
