import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/components/profile_widget.dart';
import 'package:mistry_customer/provider/data_provider.dart';
import 'package:mistry_customer/utils/config.dart';

import '../model/customer_profile_response_bck.dart';
import '../utils/images.dart';
import 'PolicyDialog.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerProfileScreen> createState() =>
      _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {
  late String gender;
  @override
  Widget build(BuildContext context) {
    var _data = ref.watch(customerProfileDataProvider);

    return Container(
      child: _data.when(
        data: (_data) {
          gender = _data.gender.toString();
          return ListView(
            physics: BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 24),
              ProfileWidget(onClicked: () async {}, gender: gender),
              const SizedBox(height: 24),
              buildName(_data),
              const SizedBox(height: 24),
              buildPersonalInfo(_data),
            ],
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildName(CustomerProfileRequest data) => Column(
        children: [
          Text(
            data.name.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            data.phonenumber.toString(),
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildPersonalInfo(CustomerProfileRequest data) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFF0F0FA)),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                "PERFSONAL INFORMATION",
                style: TextStyle(
                    fontFamily: 'Work Sans',
                    color: primaryColor,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Full Name: "),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(data!.name.toString(),
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                        ))
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(profile)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("Phone No: ")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(data!.phonenumber.toString(),
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                        ))
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(calling)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 20),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Email Address: "),
                    Expanded(
                      child: Text(data!.emailaddress.toString(),
                          style:
                              TextStyle(fontFamily: 'Work Sans', fontSize: 14)),
                    )
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(ic_message)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Age: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(data!.age.toString(),
                        style: TextStyle(
                          fontFamily: 'Work Sans',
                        ))
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(profile)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Gender: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(data!.gender.toString(),
                        style: TextStyle(fontFamily: 'Work Sans', fontSize: 14))
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(profile)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Address: "),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        data!.address!.address1.toString() +
                            "," +
                            data!.address!.address2.toString() +
                            "," +
                            data!.address!.city!,
                        style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(ic_location)),
            ),
          ),
          Card(
            elevation: 2,
            child: Container(
              decoration: BoxDecoration(color: Color(0xFFF0F0FA)),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Text(
                "ABOUT APP",
                style: TextStyle(
                    fontFamily: 'Work Sans',
                    color: primaryColor,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return PolicyDialog(
                                  mdFileName: 'privacy.md',
                                );
                              });
                        },
                        child: Text("Privacy Policy"),
                      ),
                    ),
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(ic_privacy)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            child: ListTile(
              title: Container(
                margin: EdgeInsets.only(left: 0, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return PolicyDialog(
                                mdFileName: 'terms.md',
                              );
                            });
                      },
                      child: Text("Terms & Conditions"),
                    ),
                  ],
                ),
              ),
              leading: ImageIcon(AssetImage(ic_term_condition)),
            ),
          ),
          Divider(
            height: 2,
          ),
          SizedBox(
            height: 24,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                ref.watch(shareServiceDataProvider);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/sigin',
                  (route) => false,
                );
              },
              child: Text(
                "Logout",
                style: TextStyle(
                    fontFamily: 'Work Sans',
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      );
}
