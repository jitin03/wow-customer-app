

import 'dart:convert';

BookingStatusUpdateResponse updateStatusResponse(String str) =>
    BookingStatusUpdateResponse.fromJson(json.decode(str));

class BookingStatusUpdateResponse {
  BookingStatusUpdateResponse({
    required this.customerId,
    required this.providerId,
    required this.bookingTime,
    required this.status,
    required this.serviceType,
    required this.paymentMode,
    required this.bookingAddress,
  });
  late final CustomerId customerId;
  late final ProviderId providerId;
  late final String bookingTime;
  late final String status;
  late final String serviceType;
  late final String paymentMode;
  late final String bookingAddress;

  BookingStatusUpdateResponse.fromJson(Map<String, dynamic> json){
    customerId = CustomerId.fromJson(json['customerId']);
    providerId = ProviderId.fromJson(json['providerId']);
    bookingTime = json['bookingTime'];
    status = json['status'];
    serviceType = json['serviceType'];
    paymentMode = json['paymentMode'];
    bookingAddress = json['bookingAddress'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customerId'] = customerId.toJson();
    _data['providerId'] = providerId.toJson();
    _data['bookingTime'] = bookingTime;
    _data['status'] = status;
    _data['serviceType'] = serviceType;
    _data['paymentMode'] = paymentMode;
    _data['bookingAddress'] = bookingAddress;
    return _data;
  }
}

class CustomerId {
  CustomerId({
    required this.id,
    required this.name,
    required this.emailaddress,
    required this.phonenumber,
    required this.age,
    required this.gender,
    required this.address,
  });
  late final String id;
  late final String name;
  late final String emailaddress;
  late final int phonenumber;
  late final int age;
  late final String gender;
  late final Address address;

  CustomerId.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    emailaddress = json['emailaddress'];
    phonenumber = json['phonenumber'];
    age = json['age'];
    gender = json['gender'];
    address = Address.fromJson(json['address']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['emailaddress'] = emailaddress;
    _data['phonenumber'] = phonenumber;
    _data['age'] = age;
    _data['gender'] = gender;
    _data['address'] = address.toJson();
    return _data;
  }
}

class Address {
  Address({
    required this.address1,
    required this.address2,
    required this.city,
    required this.pincode,
    required this.state,
  });
  late final String address1;
  late final String address2;
  late final String city;
  late final String pincode;
  late final String state;

  Address.fromJson(Map<String, dynamic> json){
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['address1'] = address1;
    _data['address2'] = address2;
    _data['city'] = city;
    _data['pincode'] = pincode;
    _data['state'] = state;
    return _data;
  }
}

class ProviderId {
  ProviderId({
    required this.id,
    required this.name,
    required this.serviceLists,
    required this.phonenumber,
    required this.address,
  });
  late final String id;
  late final String name;
  late final List<String> serviceLists;
  late final int phonenumber;
  late final List<Address> address;

  ProviderId.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    serviceLists = List.castFrom<dynamic, String>(json['serviceLists']);
    phonenumber = json['phonenumber'];
    address = List.from(json['address']).map((e)=>Address.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['serviceLists'] = serviceLists;
    _data['phonenumber'] = phonenumber;
    _data['address'] = address.map((e)=>e.toJson()).toList();
    return _data;
  }
}