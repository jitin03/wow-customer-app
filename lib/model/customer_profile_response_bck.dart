// To parse this JSON data, do
//
//     final ProviderProfileResponse = ProviderProfileResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

CustomerProfileRequest provideProfileFromJson(String str) =>
    CustomerProfileRequest.fromJson(json.decode(str));

String provideProfileToJson(CustomerProfileRequest data) =>
    json.encode(data.toJson());

class CustomerProfileRequest {
   Address? address;
   int? age;
   String? emailaddress;
   String? gender;
   String? name;
   int? phonenumber;
   String? userId;
   String? id;

  CustomerProfileRequest({
    this.address,
    this.age,
    this.emailaddress,
    this.gender,
    this.name,
    this.phonenumber,
    this.userId,
    this.id,
  });

  CustomerProfileRequest.fromJson(Map<String, dynamic> json)
      : address = (json['address'] as Map<String, dynamic>?) != null
            ? Address.fromJson(json['address'] as Map<String, dynamic>)
            : null,
        age = json['age'] as int?,
        emailaddress = json['emailaddress'] as String?,
        gender = json['gender'] as String?,
        name = json['name'] as String?,
        phonenumber = json['phonenumber'] as int?,
        userId = json['userId'] as String?,
        id = json['id'] as String?;

  Map<String, dynamic> toJson() => {
        'address': address?.toJson(),
        'age': age,
        'emailaddress': emailaddress,
        'gender': gender,
        'name': name,
        'phonenumber': phonenumber,
        'userId': userId,
        'id':id
      };
}

class Address {
   String? address1;
   String? address2;
   String? city;
   String? pincode;
   String? state;

  Address({
    this.address1,
    this.address2,
    this.city,
    this.pincode,
    this.state,
  });

  Address.fromJson(Map<String, dynamic> json)
      : address1 = json['address1'] as String?,
        address2 = json['address2'] as String?,
        city = json['city'] as String?,
        pincode = json['pincode'] as String?,
        state = json['state'] as String?;

  Map<String, dynamic> toJson() => {
        'address1': address1,
        'address2': address2,
        'city': city,
        'pincode': pincode,
        'state': state
      };
}
