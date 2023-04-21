import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mistry_customer/app_theme.dart';
import 'package:mistry_customer/screens/ac_service_detail_screen.dart';
import 'package:mistry_customer/screens/auth/landing_screen.dart';
import 'package:mistry_customer/screens/auth/registeration_screen.dart';
import 'package:mistry_customer/screens/auth/sign_in_screen.dart';
import 'package:mistry_customer/screens/booking_screen.dart';
import 'package:mistry_customer/screens/customer_feedback.dart';
import 'package:mistry_customer/screens/customer_profile.dart';
import 'package:mistry_customer/screens/customer_profile_setup.dart';
import 'package:mistry_customer/screens/customer_reviews.dart';
import 'package:mistry_customer/screens/dashboard_screen.dart';
import 'package:mistry_customer/screens/laundry_service_detail_screen.dart';
import 'package:mistry_customer/screens/provider_detail_screen.dart';
import 'package:mistry_customer/screens/splash_screen/splash_screen.dart';
import 'package:mistry_customer/screens/vehicle_service_detail_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Customer App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      //define the routes file here in order to access the routes any where all over the app
      routes: {
        '/dashboard': (context) => DashboadScreen(currentIndex: 0,),
        '/': (context) =>  SplashScreen(),
        '/suggestion': (context) =>  CustomerFeedback(customerId: ModalRoute.of(context)!.settings.arguments),
        '/sigin': (context) =>  SignIn(),
        '/register':(context)=>RegistrationScreen(),
        '/bookings': (context) => DashboadScreen(currentIndex: 1,),
        '/vehicle-service': (context) => VehicleServiceDetailScreen(serviceName: ModalRoute.of(context)!.settings.arguments),
        '/laundry-service': (context) => LaundryServiceDetailScreen(serviceName: ModalRoute.of(context)!.settings.arguments),
        '/appliances-service': (context) => ACServiceDetailScreen(serviceName: ModalRoute.of(context)!.settings.arguments),
        '/booking':(context)=> BookingScreen(),
        '/provider-detail': (context)=> ProviderDetailScreen(),
        'profile':(context)=> DashboadScreen(currentIndex: 2,),
        '/customer-reviews': (context) => CustomerReviews(providerId: ModalRoute.of(context)!.settings.arguments),


        // '/add-service': (context) =>  ProviderAddServiceFragment(),
      },

    );
  }
}


