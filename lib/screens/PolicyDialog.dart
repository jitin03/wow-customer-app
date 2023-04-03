import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mistry_customer/utils/config.dart';

class PolicyDialog extends StatelessWidget {
  PolicyDialog({
    this.radius = 8,
    required this.mdFileName,
  }) : assert(mdFileName.contains('.md'),
            'The file must contain the .md extension');

  final double radius;
  final String mdFileName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: Container(
        height: 320,
        child: Column(
          children: [
            Expanded(

              child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 150)).then((value) {
                  return rootBundle.loadString('assets/$mdFileName');
                }),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Markdown(
                      data: snapshot.data!,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            ElevatedButton(
              // padding: EdgeInsets.all(0),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0Xff5F60B9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0)),
                // Background color
              ),
              onPressed: () => Navigator.of(context).pop(),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(radius),
              //     bottomRight: Radius.circular(radius),
              //   ),
              // ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radius),
                    bottomRight: Radius.circular(radius),
                  ),
                ),
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                child: Text(
                  "CLOSE",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Work Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
