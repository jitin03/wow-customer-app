import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mistry_customer/model/customer_coupons_response.dart';
import 'package:mistry_customer/model/customer_review_request.dart';
import 'package:mistry_customer/model/customer_reviews_response.dart';
import 'package:mistry_customer/model/notification_response.dart';
import 'package:mistry_customer/model/validate_wow_coupon_response.dart';
import 'package:mistry_customer/services/shared_service.dart';

import '../utils/config.dart';
import 'package:http/http.dart' as http;

class CouponService {


  Future<ValidateCouponResponse> validateCoupon(
      String couponCode,String serviceName) async {
    var customerId = await SharedService.getCustomerId();
    final queryParameters = {
      'couponCode': couponCode,
      'customerId': customerId,
      'serviceName': serviceName,
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL, Config.couponsEndPoint , queryParameters);
    print(url);
    Response response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {

      return validateCouponResponse(response.body);
    } else {

      throw Exception(response.reasonPhrase);
    }
  }


  Future<ValidateCouponResponse> validateReferralCoupon(
      String couponCode,String serviceName) async {

    final queryParameters = {
      'couponCode': couponCode,
      'serviceName': serviceName,
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL, Config.referralCouponsEndPoint , queryParameters);
    print(url);
    Response response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {

      return validateCouponResponse(response.body);
    } else {

      throw Exception(response.reasonPhrase);
    }
  }



  Future<List<WowCustomerCoupons>> getCustomerCouponsWithServiceName(String serviceName
      ) async {
    var customerId = await SharedService.getCustomerId();
    final queryParameters = {
      'customerId': customerId,
      'serviceName': serviceName,
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL, Config.couponsEndPoint+"/customer/service" , queryParameters);

    print(url);
    Response response = await http.get(url, headers: requestHeaders);

    // print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      return wowCouponsResponseFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }


  Future<List<WowCustomerCoupons>> getCustomerReferralCouponsWithServiceName(String serviceName
      ) async {

    final queryParameters = {
      'serviceName': serviceName,
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL, Config.referralCouponsEndPoint+"/referralCode" , queryParameters);

    print(url);
    Response response = await http.get(url, headers: requestHeaders);

    // print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      return wowCouponsResponseFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}

final couponServiceProvider = Provider<CouponService>((ref) => CouponService());
