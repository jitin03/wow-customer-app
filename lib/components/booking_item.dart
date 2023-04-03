import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({required this.cardChild});

  // final  Color colour;
  final Widget cardChild;
  // final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(0XFFEBEBEB),
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              )),


          child: cardChild),
    );
  }
}
