import 'package:flutter/material.dart';

class Config {
  static const String appName = "Wow!";
  // static const String apiURL = '127.0.0.1:8989'; //IOS
  // static const String apiURL = '10.0.2.2:8989'; //ANDROID
  static const String apiURL = 'a3992b62ac3fa47beb5687155c17e860-274100500.us-east-1.elb.amazonaws.com:80'; //AWS
  static const loginAPI = "/api/v1/auth/login";
  static const registerAPI = "/api/v1/auth/signup";
  static const providerBookingAPI = "/api/v1/booking/provider";
  static const providersForCategoryAPI = "api/v1/providers/categoryies";
  static const providerDetailByIdAPI = "api/v1/providers/";
  static const bookingPostAPI = "/api/v1/booking";
  static const customersBookingAPI = '/api/v1/booking/customer';
  static const customerProfileAPI = '/api/v1/customers';
  static const requestOtpAPI = "/api/v1/auth/requestOtp";
  static const verifyOtpAPI = "/api/v1/auth/verifyOtp/";
  static const reviewsEndPoint='/api/v1/reviews';
  static const notificationEndPoint='/api/v1/notifications';


  static const List<String> appBarTitles = [
    "Dashboard",
    "Booking",
    // "Payment",
    "Profile",
    "Wow Support"
  ];

  // static const userProfileAPI = "/users/user-Profile";
}

const CAR_CLEARNING_COLOR = Color(0XFF1C1F34);
const LAUNDRY_COLOR = Color(0XFF1C1F34);

const APP_NAME = 'Handyman Services';
const DEFAULT_LANGUAGE = 'en';

const primaryColor = Color(0xFF5F60B9);
//var appFontFamily = GoogleFonts.workSans().fontFamily;

const DOMAIN_URL = ''; // Don't add slash at the end of the url
const BASE_URL = "$DOMAIN_URL/api/";

const IOS_LINK_FOR_PARTNER =
    "https://apps.apple.com/in/app/handyman-provider-app/id1596025324";

const ONESIGNAL_APP_ID = '';
const ONESIGNAL_REST_KEY = "";
const ONESIGNAL_CHANNEL_ID = "";

const TERMS_CONDITION_URL = 'https://iqonic.design/terms-of-use/';
const PRIVACY_POLICY_URL = 'https://iqonic.design/privacy-policy/';
const HELP_SUPPORT_URL = 'https://iqonic.desky.support/';
const PURCHASE_URL =
    'https://codecanyon.net/item/handyman-service-flutter-ondemand-home-services-app-with-complete-solution/33776097?s_rank=5';

const GOOGLE_MAPS_API_KEY = '';

const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';

DateTime todayDate = DateTime(2022, 8, 24);

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";
double defaultRadius = 8.0;
