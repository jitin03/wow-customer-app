import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mistry_customer/model/customer_review_request.dart';
import 'package:mistry_customer/model/customer_reviews_response.dart';
import 'package:mistry_customer/model/notification_response.dart';

import '../utils/config.dart';
import 'package:http/http.dart' as http;

class NotificationService {


  Future<List<NotificationResponse>> getBookingNotification(
      String bookingId) async {
    final queryParameters = {
      'bookingId': bookingId,
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL, Config.notificationEndPoint , queryParameters);

    print(url);
    Response response = await http.get(url, headers: requestHeaders);

    // print(response.body);
    print(notificationResponseFromJson(response.body));
    if (response.statusCode == 200) {
      // print(notificationResponseFromJson(response.body)[0].message);
      return notificationResponseFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());
