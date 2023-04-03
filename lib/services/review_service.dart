import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mistry_customer/model/customer_review_request.dart';
import 'package:mistry_customer/model/customer_reviews_response.dart';

import '../utils/config.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  Future<String> createCustomerReview(
    CustomerReviewRequest model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.reviewsEndPoint,
    );

    print(url);
    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<String> createCustomerFeedback(
      CustomerFeedbackRequest model,
      ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(
      Config.apiURL,
      Config.reviewsEndPoint+"/feedback",
    );

    print(url);
    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );
    print(response.body);
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<CustomerReviewsResponse>> getProviderReviews(
      String providerId) async {
    final queryParameters = {
      'providerId': providerId,
    };

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };
    var url = Uri.http(
        Config.apiURL, Config.reviewsEndPoint + "/provider", queryParameters);

    print(url);
    Response response = await http.get(url, headers: requestHeaders);

    print(customerReviewsResponseFromJson(response.body));
    if (response.statusCode == 200) {
      print(customerReviewsResponseFromJson(response.body));
      return customerReviewsResponseFromJson(response.body);
    } else {
      print(response.reasonPhrase);
      throw Exception(response.reasonPhrase);
    }
  }
}

final reviewServiceProvider = Provider<ReviewService>((ref) => ReviewService());
