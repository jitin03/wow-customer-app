import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart';
import 'package:mistry_customer/model/customer_profile_response_bck.dart';
import 'package:mistry_customer/services/auth_service.dart';
import 'package:mistry_customer/services/category_service.dart';
import 'package:mistry_customer/services/shared_service.dart';
import 'package:mistry_customer/utils/config.dart';
import 'package:riverpod/riverpod.dart';

class CustomerService {
  static Future<bool> saveCustomerProfile(
      CustomerProfileRequest serviceRequest) async {
    print(serviceRequest.toJson());
    var userDetails = await SharedService.userDetails();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userDetails!.accessToken}'
    };
    serviceRequest.userId = userDetails.userId;
    var url = Uri.http(Config.apiURL, Config.customerProfileAPI);

    print(url);
    print(serviceRequest.toJson());
    Response response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(serviceRequest.toJson()),
    );
    print(response.statusCode);
    print(response.reasonPhrase);
    if (response.statusCode == 201) {

      return true;
    } else {
      return false;
    }
  }

   Future<CustomerProfileRequest> getCustomerProfileByPhoneNo() async{

    var loginDetails = await SharedService.loginDetails();



    final queryParameters = {
      'phoneNo': AUTHService.getUserPhoneNo(loginDetails!.jwt),
    };
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.jwt}'
    };
    var url = Uri.http(
        Config.apiURL,
        Config.customerProfileAPI,queryParameters
    );
    print(url);
    Response response = await http.get(url,headers: requestHeaders);

    print(response.body);
    if (response.statusCode == 200) {
      await SharedService.setCustomerId(
        provideProfileFromJson(response.body).id.toString(),
      );
      return provideProfileFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }

  }


  Future<CustomerProfileRequest> getCustomerProfileById() async{

    var loginDetails = await SharedService.loginDetails();
    var customerId = await SharedService.getCustomerId();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.jwt}'
    };
    var url = Uri.http(
        Config.apiURL,
        Config.customerProfileAPI+"/${customerId}"
    );
    print(url);
    Response response = await http.get(url,headers: requestHeaders);

    print(response.body);
    if (response.statusCode == 200) {
      await SharedService.setCustomerId(
        provideProfileFromJson(response.body).id.toString(),
      );
      return provideProfileFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }

  }
}
final customerServiceProvider =
Provider<CustomerService>((ref) => CustomerService());