import 'dart:convert';

List<CustomerBookingResponse> customerBookingResponseFromJson(String str) =>
    List<CustomerBookingResponse>.from(
        json.decode(str).map((x) => CustomerBookingResponse.fromJson(x)));
String customerBookingResponseToJson(CustomerBookingResponse data) =>
    json.encode(data.toJson());

class CustomerBookingResponse {
  CustomerBookingResponse({
    required this.status,
    required this.paymentStatus,
    required this.paymentMode,
    required this.bookingTime,
    required this.bookingAddress,
    required this.grossAmount,
    required this.serviceLists,
    required this.customerId,
    required this.bookingId,
    required this.providerId,
    required this.providerName,
  });
  late final String status;
  late final String paymentStatus;
  late final String paymentMode;
  late final String bookingTime;
  late final String bookingAddress;
  late final String grossAmount;
  late final List<ServiceLists> serviceLists;
  late final List<CustomerId> customerId;
  late final num bookingId;
  late final List<String> providerId;
  late final List<String> providerName;

  CustomerBookingResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    paymentMode = json['paymentMode'];
    bookingTime = json['bookingTime'];
    bookingAddress = json['bookingAddress'];
    grossAmount = json['grossAmount'];
    serviceLists = List.from(json['serviceLists']).map((e)=>ServiceLists.fromJson(e)).toList();
    customerId = List.from(json['customerId']).map((e)=>CustomerId.fromJson(e)).toList();
    bookingId = json['bookingId'];
    providerId = List.castFrom<dynamic, String>(json['providerId']);
    providerName = List.castFrom<dynamic, String>(json['providerName']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['paymentStatus'] = paymentStatus;
    _data['paymentMode'] = paymentMode;
    _data['bookingTime'] = bookingTime;
    _data['bookingAddress'] = bookingAddress;
    _data['grossAmount'] = grossAmount;
    _data['serviceLists'] = serviceLists.map((e)=>e.toJson()).toList();
    _data['customerId'] = customerId.map((e)=>e.toJson()).toList();
    _data['bookingId'] = bookingId;
    _data['providerId'] = providerId;
    _data['providerName'] = providerName;
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

  ServiceLists.fromJson(Map<String, dynamic> json){
    name = json['name'];
    subCategories = List.from(json['subCategories']).map((e)=>SubCategories.fromJson(e)).toList();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['subCategories'] = subCategories.map((e)=>e.toJson()).toList();
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

  SubCategories.fromJson(Map<String, dynamic> json){
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

class CustomerId {
  CustomerId({

    required this.name,
    required this.emailaddress,
    required this.userId,
    required this.phonenumber,
    required this.age,
    required this.gender,
    required this.address,

  });
  late final String _id;
  late final String name;
  late final String emailaddress;
  late final String userId;
  late final num phonenumber;
  late final num age;
  late final String gender;
  late final Address address;
  late final String _class;

  CustomerId.fromJson(Map<String, dynamic> json){
    _id = json['_id'];
    name = json['name'];
    emailaddress = json['emailaddress'];
    userId = json['userId'];
    phonenumber = json['phonenumber'];
    age = json['age'];
    gender = json['gender'];
    address = Address.fromJson(json['address']);
    _class = json['_class'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = _id;
    _data['name'] = name;
    _data['emailaddress'] = emailaddress;
    _data['userId'] = userId;
    _data['phonenumber'] = phonenumber;
    _data['age'] = age;
    _data['gender'] = gender;
    _data['address'] = address.toJson();
    _data['_class'] = _class;
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
