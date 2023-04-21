import 'package:flutter/material.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

enum CarServices { ALL, CAR_WASHING }

class ServiceTypes extends StatelessWidget {
  final String servicename;
  final String iconName;
  late bool isSearchedEnabled;
  final void Function()? selectedSearch;

  ServiceTypes(
      {required this.servicename,
      required this.iconName,
      required this.isSearchedEnabled,
       required this.selectedSearch});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: selectedSearch,
            child: Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0XFFAFB3D3)),
                  shape: BoxShape.circle,
                  color: Color(0XFFF6F7F9),),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ImageIcon(
                      AssetImage(iconName),
                      size: 50,
                      color: primaryColor,
                    ),
                  ),
                  if (isSearchedEnabled)
                    Align(
                      alignment: Alignment.topRight,
                      child: ImageIcon(
                        AssetImage(icon_check,),
                        color: primaryColor,
                      ),
                    )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(servicename),
        ],
      ),
    );
  }
}
