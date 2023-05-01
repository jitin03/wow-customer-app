

import 'dart:convert';

List<WowCustomerCoupons> wowCouponsResponseFromJson(String str) =>
    List<WowCustomerCoupons>.from(
        json.decode(str).map((x) => WowCustomerCoupons.fromJson(x)));
String wowCouponsResponseToJson(WowCustomerCoupons data) =>
    json.encode(data.toJson());


class WowCustomerCoupons {
  WowCustomerCoupons({
    required this.expiryTime,
    required this.usedLimit,
    required this.discountRate,
    required this.serviceName,
    required this.couponCode,
  });
  late final String expiryTime;
  late final int usedLimit;
  late final int discountRate;
  late final String serviceName;
  late final String couponCode;

  WowCustomerCoupons.fromJson(Map<String, dynamic> json){
    expiryTime = json['expiryTime'];
    usedLimit = json['usedLimit'];
    discountRate = json['discountRate'];
    serviceName = json['serviceName'];
    couponCode = json['couponCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['expiryTime'] = expiryTime;
    _data['usedLimit'] = usedLimit;
    _data['discountRate'] = discountRate;
    _data['serviceName'] = serviceName;
    _data['couponCode'] = couponCode;
    return _data;
  }
}