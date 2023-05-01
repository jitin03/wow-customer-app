import 'package:flutter/material.dart';
import 'package:mistry_customer/utils/config.dart';

class ACFanMotorServiceData extends StatelessWidget {
  const ACFanMotorServiceData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
return Container(
  color: Colors.white,
  padding: EdgeInsets.all(20.0),
  child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Table(
      border: TableBorder.all(color: Colors.black),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Service Type',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Charges',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Work Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Outdoor Fan Motor')),
            Center(child: Text('\u{20B9} 1600')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Blower motor replacement')),
            Center(child: Text('\u{20B9} 2000')),
          ],
        ),

      ],
    ),
  ),
);

  }
}
