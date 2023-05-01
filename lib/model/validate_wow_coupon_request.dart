


import 'dart:convert';

String validateCouponRequestToJson(ValidateCouponRequest data) => json.encode(data.toJson());
class ValidateCouponRequest {
  ValidateCouponRequest({
     this.couponCode,
  });
   String? couponCode;

  ValidateCouponRequest.fromJson(Map<String, dynamic> json){
    couponCode = json['couponCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['couponCode'] = couponCode;
    return _data;
  }
}