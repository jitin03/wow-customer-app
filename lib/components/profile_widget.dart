import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';

class ProfileWidget extends StatelessWidget {
 final String gender;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.onClicked,
    required this.gender
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(gender),
          // Positioned(
          //   bottom: 0,
          //   right: 4,
          //   child: buildEditIcon(color),
          // ),
        ],
      ),
    );
  }

  Widget buildImage( gender) {
    ImageProvider<Object> image;
    if(gender=='Male'){
      image = AssetImage(male_default_profile_iamge);
    }else{
       image = AssetImage(female_default_profile_iamge);
    }




    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor,
          width: 3.0,
        ),
      ),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(onTap: onClicked),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}