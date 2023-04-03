import 'dart:convert';

List<CustomerBookingResponse> customerBookingResponseFromJson(String str) =>
    List<CustomerBookingResponse>.from(
        json.decode(str).map((x) => CustomerBookingResponse.fromJson(x)));
String customerBookingResponseToJson(CustomerBookingResponse data) =>
    json.encode(data.toJson());

class CustomerBookingResponse {
  CustomerBookingResponse({
    required this.serviceType,
    required this.status,
    required this.paymentMode,
    required this.bookingTime,
    required this.customerId,
    required this.bookingId,
    required this.providerId,
    required this.providerName,
    required this.bookingAddress,
  });
  late final String serviceType;
  late final String status;
  late final String paymentMode;
  late final String bookingTime;
  late final List<dynamic> customerId;
  late final int bookingId;
  late final List<String> providerId;
  late final List<String> providerName;
  late final String bookingAddress;

  CustomerBookingResponse.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    status = json['status'];
    paymentMode = json['paymentMode'];
    bookingTime = json['bookingTime'];
    customerId = List.castFrom<dynamic, dynamic>(json['customerId']);
    bookingId = json['bookingId'];
    providerId = List.castFrom<dynamic, String>(json['providerId']);
    providerName = List.castFrom<dynamic, String>(json['providerName']);
    bookingAddress = json['bookingAddress'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['serviceType'] = serviceType;
    _data['status'] = status;
    _data['paymentMode'] = paymentMode;
    _data['bookingTime'] = bookingTime;
    _data['customerId'] = customerId;
    _data['bookingId'] = bookingId;
    _data['providerId'] = providerId;
    _data['providerName'] = providerName;
    _data['bookingAddress']=bookingAddress;
    return _data;
  }
}
