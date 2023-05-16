import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/config.dart';

class CustomerSupportScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child:  Image(
                    image: AssetImage("assets/images/support_header.png"),
                  )
              ),
            ),

            Card(
              color: Color(0xffE2E3FF),
              child: ListTile(
                title: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 20, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Call Us",style: TextStyle(fontFamily: 'Work Sans'),),
                                SelectableText("(+91) 8949862707",style: TextStyle(fontFamily: 'Work Sans',fontWeight: FontWeight.w300),)

                              ],
                            ),
                          )
                    ],
                  ),
                ),
                leading: Image(
                  image: AssetImage("assets/images/call_support.png"),
                )
              ),
            ),

            Card(
              color: Color(0xffE2E3FF),
              child: ListTile(
                  title: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email Us",style: TextStyle(fontFamily: 'Work Sans'),),
                              SelectableText("services@wowservice.co.in",style: TextStyle(fontFamily: 'Work Sans',fontWeight: FontWeight.w300),)

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  leading: Image(
                    image: AssetImage("assets/images/support_email.png"),
                  )
              ),
            ),

            Card(
              color: Color(0xffE2E3FF),
              child: ListTile(
                  title: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("WhatsApp Support",style: TextStyle(fontFamily: 'Work Sans'),),
                              SelectableText("(+91) 8949862707",style: TextStyle(fontFamily: 'Work Sans',fontWeight: FontWeight.w300),)

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  leading: Image(
                    image: AssetImage("assets/images/support_whatsapp.png"),
                  )
              ),
            ),

            SizedBox(height: 20,)

          ],
        ),
      ),
    );
  }
}
