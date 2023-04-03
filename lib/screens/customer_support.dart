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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "WowService support 24*7 ",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "WhatsApp or Call us @",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "(+91) 9780032269 ",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0Xff6C757D),
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Email @",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "services@wowservice.co.in",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w600,
                      color: Color(0Xff6C757D),
                      fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
