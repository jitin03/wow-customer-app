import 'dart:convert';

List<BookingResponse> billingResponseFromJson(String str) =>
    List<BookingResponse>.from(
        json.decode(str).map((x) => BookingResponse.fromJson(x)));
//
String billingResponseToJson(BookingResponse data) =>
    json.encode(data.toJson());

class BookingResponse {
  BookingResponse({
    required this.status,
    required this.paymentStatus,
    required this.paymentMode,
    required this.bookingTime,
    required this.bookingAddress,
    required this.grossAmount,
    required this.serviceLists,
    required this.bookingId,
    required this.customerId,
    required this.customerPhoneNo,
    required this.customerEmail,
    required this.providerId,
    required this.discountRate,
    required this.discountPrice,
    required this.couponCode,
  });
  late final String status;
  late final String paymentStatus;
  late final String paymentMode;
  late final String bookingTime;
  late final String bookingAddress;
  late final String grossAmount;
  late final List<ServiceLists> serviceLists;
  late final num bookingId;
  late final List<String> customerId;
  late final List<num> customerPhoneNo;
  late final List<String> customerEmail;
  late final List<String> providerId;
  late final num discountRate;
  late final num discountPrice;
  late final String couponCode;

  BookingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    paymentMode = json['paymentMode'];
    bookingTime = json['bookingTime'];
    bookingAddress = json['bookingAddress'];
    grossAmount = json['grossAmount'];
    discountRate = json['discountRate'];
    discountPrice = json['discountPrice'];
    couponCode = json['couponCode'];
    serviceLists = List.from(json['serviceLists'])
        .map((e) => ServiceLists.fromJson(e))
        .toList();
    bookingId = json['bookingId'];
    customerId = List.castFrom<dynamic, String>(json['customerId']);
    customerPhoneNo = List.castFrom<dynamic, num>(json['customerPhoneNo']);
    customerEmail = List.castFrom<dynamic, String>(json['customerEmail']);
    providerId = List.castFrom<dynamic, String>(json['providerId']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['paymentStatus'] = paymentStatus;
    _data['paymentMode'] = paymentMode;
    _data['bookingTime'] = bookingTime;
    _data['bookingAddress'] = bookingAddress;
    _data['grossAmount'] = grossAmount;
    _data['serviceLists'] = serviceLists.map((e) => e.toJson()).toList();
    _data['bookingId'] = bookingId;
    _data['customerId'] = customerId;
    _data['customerPhoneNo'] = customerPhoneNo;
    _data['customerEmail'] = customerEmail;
    _data['providerId'] = providerId;
    return _data;
  }
}

class ServiceLists {
  ServiceLists({
    required this.name,
    required this.subCategories,
    required this.price,
  });
  late final String name;
  late final List<SubCategories> subCategories;
  late final num price;

  ServiceLists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    subCategories = List.from(json['subCategories'])
        .map((e) => SubCategories.fromJson(e))
        .toList();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['subCategories'] = subCategories.map((e) => e.toJson()).toList();
    _data['price'] = price;
    return _data;
  }
}

class SubCategories {
  SubCategories({
    required this.name,
    required this.price,
    required this.count,
  });
  late final String name;
  late final num price;
  late final String count;

  SubCategories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['price'] = price;
    _data['count'] = count;
    return _data;
  }
}
