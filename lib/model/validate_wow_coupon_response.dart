

import 'dart:convert';

ValidateCouponResponse validateCouponResponse(String str) =>
    ValidateCouponResponse.fromJson(json.decode(str));

class ValidateCouponResponse {
  ValidateCouponResponse({
    required this.message,
    required this.usedCount,
    required this.discountRate,
  });
  late final String message;
  late final int usedCount;
  late final int discountRate;

  ValidateCouponResponse.fromJson(Map<String, dynamic> json){
    message = json['message'];
    usedCount = json['usedCount'];
    discountRate = json['discountRate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['usedCount'] = usedCount;
    _data['discountRate'] = discountRate;
    return _data;
  }
}