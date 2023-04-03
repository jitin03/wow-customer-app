
import 'dart:convert';

String bookingRequestToJson(BookingRequest data) => json.encode(data.toJson());


class BookingRequest {
  BookingRequest({
     this.bookingTime,
     this.customerId,
     this.paymentMode,
     this.providerId,
     this.serviceType,
     this.status,
    this.bookingAddress,
  });
  String? bookingTime;
  String? customerId;
  String? paymentMode;
  String? providerId;
  String? serviceType;
 String? status;
 String? bookingAddress;

  BookingRequest.fromJson(Map<String, dynamic> json){
    bookingTime = json['bookingTime'];
    customerId = json['customerId'];
    paymentMode = json['paymentMode'];
    providerId = json['providerId'];
    serviceType = json['serviceType'];
    status = json['status'];
    bookingAddress = json['bookingAddress'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bookingTime'] = bookingTime;
    _data['customerId'] = customerId;
    _data['paymentMode'] = paymentMode;
    _data['providerId'] = providerId;
    _data['serviceType'] = serviceType;
    _data['status'] = status;
    _data['bookingAddress'] = bookingAddress;
    return _data;
  }
}