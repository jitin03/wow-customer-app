import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'images.dart';

class Config {
  static const String appName = "Wow!";
  // static const String apiURL = '127.0.0.1:8989'; //IOS
  // static const String apiURL = '10.0.2.2:8989'; //ANDROID
  static const String apiURL =
      'a3992b62ac3fa47beb5687155c17e860-274100500.us-east-1.elb.amazonaws.com:80'; //AWS
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
  static const reviewsEndPoint = '/api/v1/reviews';
  static const notificationEndPoint = '/api/v1/notifications';
  static const couponsEndPoint = '/api/v1/coupons';
  static const referralCouponsEndPoint = '/api/v1/referral/coupons';

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
const AC_REPAIR_CHARGES = 280;

const Map<String, Map<String, String>> WOW_SERVICES = {
  'service1': {
    'serviceIcon': 'assets/icons/category_laundry.png',
    'servicePath': '/laundry-service',
    'routeArgument': 'All-Laundry',
    'serviceName': 'Laundry'
  },
  'service2': {
    'serviceIcon': ic_ac_repair,
    'servicePath': '/appliances-service',
    'routeArgument': 'All-Appliances',
    'serviceName': 'AC Services'
  },
  // 'service3': {
  //   'serviceIcon': 'assets/icons/maid_icon.png',
  //   'servicePath': '/maid-service',
  //   'routeArgument': 'All-Maids',
  //   'serviceName': 'Maid Service'
  // },
};

const Map<String, Map<String, String>> WOW_FEATURED_SERVICES = {
  'service1': {
    'serviceIcon': 'assets/images/featured_iron_laundry.png',
    'servicePath': '/laundry-service',
    'routeArgument': 'Ironing',
    'serviceName': 'Laundry',
    'featuredServiceName': "Ironing"
  },
  'service2': {
    'serviceIcon': 'assets/images/feature_washing.png',
    'servicePath': '/laundry-service',
    'routeArgument': 'Washing',
    'serviceName': 'Laundry',
    'featuredServiceName': "Washing"
  },
  'service3': {
    'serviceIcon': 'assets/images/feature_dry_clean.png',
    'servicePath': '/laundry-service',
    'routeArgument': 'Dry Cleaning',
    'serviceName': 'Laundry',
    'featuredServiceName': "Dry Cleaning"
  },
  'service4': {
    'serviceIcon': 'assets/images/feature_shoe_dry_clean.png',
    'servicePath': '/laundry-service',
    'routeArgument': 'Dry Cleaning',
    'serviceName': 'Laundry',
    'featuredServiceName': "Shoe Dry Cleaning"
  },
  'service5': {
    'serviceIcon': 'assets/images/feature_ac_service.png',
    'servicePath': '/appliances-service',
    'routeArgument': 'AC Clean Service(split)',
    'serviceName': 'AC Service',
    'featuredServiceName': "AC Cleaning"
  },
};
class Utils {
  static formatPrice(double price) => '\u{20B9} ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}