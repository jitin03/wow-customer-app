import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mistry_customer/model/billing_response_model.dart';
import 'package:mistry_customer/model/booking_request.dart';
import 'package:mistry_customer/model/create_booking_order.dart';
import 'package:mistry_customer/model/create_booking_order_response.dart';
import 'package:mistry_customer/model/customer_booking_response.dart';
import 'package:mistry_customer/model/login_response_model.dart';
import 'package:mistry_customer/model/update_booking_status.dart';
import 'package:mistry_customer/services/shared_service.dart';
import 'package:mistry_customer/utils/config.dart';

import '../model/update_booking_request.dart';

class BookingService {
  static var client = http.Client();
  Future<double> saveBooking(
    BookingRequest model,
  ) async {
    print(model.toJson());
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.bookingPostAPI,
    );

    print(url);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    if (response.statusCode == 201) {
      return double.parse(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<BookingStatusUpdateResponse> updateBookingStatus(
      BookingStatusUpdateRequest status,String bookingId
      ) async {

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.bookingPostAPI+"/${bookingId}/status",
    );

    print(url);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(status.toJson()),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return updateStatusResponse(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<BookingStatusUpdateResponse> updateBookingPaymentMode(
      BookingPaymentUpdateRequest status,String bookingId
      ) async {

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.bookingPostAPI+"/${bookingId}/mode",
    );

    print(url);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(status.toJson()),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return updateStatusResponse(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }


  Future<CreateBookingOrderResponse> createBookingCashFreeOder(
      CreateBookingOrder model,
      ) async {
    print(model.toJson());
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.bookingPostAPI+'/create-order',
    );

    print(url);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    if (response.statusCode == 201) {
      return createOrderResponse(response.body);
    } else {

      throw Exception(response.reasonPhrase);
    }
  }
  Future<List<BookingResponse>> getCustomerBooking(String bookingId) async {

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    var url =
    Uri.http(Config.apiURL, Config.bookingPostAPI+'/${bookingId}');


    var response = await client.get(
      url,
      headers: requestHeaders,

    );
    print(url);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return billingResponseFromJson(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<List<CustomerBookingResponse>> getCustomerBookings() async {
    var customerId = await SharedService.getCustomerId();
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };
    final queryParameters = {
      // 'customerId': loginDetails.userId,
      'customerId': customerId,
    };

    var url =
        Uri.http(Config.apiURL, Config.customersBookingAPI, queryParameters);

    print(url);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) {
      return customerBookingResponseFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}

final bookingServiceProvider =
    Provider<BookingService>((ref) => BookingService());
