import 'package:flutter/material.dart';
import 'package:mistry_customer/utils/config.dart';

class ACGasChargeServiceData extends StatelessWidget {
  const ACGasChargeServiceData({Key? key}) : super(key: key);

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
            Center(child: Text('Gas Charging')),
            Center(child: Text('\u{20B9} 2500')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Flair nut replacement')),
            Center(child: Text('\u{20B9} 150')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Copper Coil repair')),
            Center(child: Text('\u{20B9} 450(labour)')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Copper Coil Condensor(1 ton Split)')),
            Center(child: Text('\u{20B9} 3000')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Copper Coil Condensor(2 ton Split)')),
            Center(child: Text('\u{20B9} 3500')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('Compressor < 1 ton')),
            Center(child: Text('\u{20B9} 6000')),
          ],
        ),
        TableRow(
          children: [
            Center(child: Text('1 =< Compressor >= 2 ton')),
            Center(child: Text('\u{20B9} 8700')),
          ],
        )
      ],
    ),
  ),
);

  }
}
