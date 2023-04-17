
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/screens/auth/sign_in_screen.dart';
import 'package:mistry_customer/screens/booking_screen.dart';
import 'package:mistry_customer/screens/customer_home.dart';
import 'package:mistry_customer/screens/customer_profile.dart';
import 'package:mistry_customer/screens/customer_support.dart';
import 'package:mistry_customer/screens/customers_booking.dart';
import 'package:mistry_customer/screens/provider_detail_screen.dart';
import 'package:mistry_customer/screens/vehicle_service_detail_screen.dart';
import 'package:mistry_customer/screens/vehicle_service_detail_screen.dart';
import 'package:mistry_customer/services/shared_service.dart';
import 'package:mistry_customer/utils/colors.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:mistry_customer/utils/images.dart';
import 'package:upgrader/upgrader.dart';

class DashboadScreen extends ConsumerStatefulWidget {
  late final int currentIndex;

  DashboadScreen({required this.currentIndex});
  @override
  ConsumerState<DashboadScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<DashboadScreen> {
  int currentIndex = 0;
  bool isUserAuthenticated = false;
  List<Widget> fragmentList = [
    CustomerHomeFragment(),

    CustomerBookings(),
    CustomerProfileScreen(),
    CustomerSupportScreen(),
    // ProviderDetailScreen(),
    // BookingScreen(),
    // ProviderBookings(),
    // ProviderAddServiceFragment(),
    // ProviderProfileFragment(),
  ];
  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Config.appBarTitles[currentIndex],
        ),

        backgroundColor:primaryColor,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: "Work Sans",
            fontSize: 18,
            fontWeight: FontWeight.w800),
      ),
      body: UpgradeAlert(
        upgrader: Upgrader(durationUntilAlertAgain: const Duration(days:1) ,
        dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino: UpgradeDialogStyle.material ),
        child: SafeArea(
          child: fragmentList[currentIndex],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: primaryColor.withOpacity(0.02),
          indicatorColor: primaryColor.withOpacity(0.1),
          labelTextStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          destinations: const [
            NavigationDestination(
              icon: ImageIcon(
                AssetImage(ic_home),
                color: appTextSecondaryColor,
              ),
              // selectedIcon: ic_fill_home.iconImage(color: context.primaryColor),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: ImageIcon(AssetImage(total_booking),
                  color: appTextSecondaryColor),
              // selectedIcon: fill_ticket.iconImage(color: context.primaryColor),
              label: 'Booking',
            ),
            // NavigationDestination(
            //   icon: ImageIcon(AssetImage(un_fill_wallet),
            //       color: appTextSecondaryColor),
            //   // selectedIcon: ic_fill_wallet.iconImage(color: context.primaryColor),
            //   label: "Payment",
            // ),
            NavigationDestination(
              icon:
                  ImageIcon(AssetImage(profile), color: appTextSecondaryColor),
              // selectedIcon: ic_fill_profile.iconImage(color: context.primaryColor),
              label: "Profile",
            ),
            NavigationDestination(
              icon:
              ImageIcon(AssetImage(support), color: appTextSecondaryColor),
              // selectedIcon: ic_fill_profile.iconImage(color: context.primaryColor),
              label: "Wow Support",
            ),
          ],
          onDestinationSelected: (index) {
            print(currentIndex);
            print(index);
            setState(() {
              currentIndex = index;
              // ref.invalidate(bookingDataProvider);
            });
          },
        ),
      ),
    );
  }

  Future<bool>isUserLoggedin() async {
    return await SharedService.isLoggedIn();
  }
}
