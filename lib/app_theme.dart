import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mistry_customer/utils/colors.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/colors.dart';
import 'package:mistry_customer/utils/config.dart';




class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      outlineVariant: borderColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.workSans().fontFamily,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: appTextSecondaryColor),
    textTheme: GoogleFonts.workSansTextTheme(),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: borderColor,
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
      backgroundColor: Colors.white,
    ),
    cardColor: cardColor,
    appBarTheme: AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light, statusBarColor: primaryColor)),
    // dialogTheme: DialogTheme(shape: dialogShape()),
    navigationBarTheme: NavigationBarThemeData(labelTextStyle: MaterialStateProperty.all(TextStyle(fontSize: 10))),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );


}
