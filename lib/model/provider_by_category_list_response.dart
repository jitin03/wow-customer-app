

import 'dart:convert';

List<ProvidersByCategoryResponse> providersByCategoryResponseFromJson(String str) =>
    List<ProvidersByCategoryResponse>.from(json.decode(str).map((x) => ProvidersByCategoryResponse.fromJson(x)));
String providersByCategoryResponseToJson(ProvidersByCategoryResponse data) => json.encode(data.toJson());


class ProvidersByCategoryResponse {
  ProvidersByCategoryResponse({
    required this.categoryName,
    required this.providerDetail,
  });
  late final String categoryName;
  late final ProviderDetail providerDetail;

  ProvidersByCategoryResponse.fromJson(Map<String, dynamic> json){
    categoryName = json['categoryName'];
    providerDetail = ProviderDetail.fromJson(json['providerDetail']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['categoryName'] = categoryName;
    _data['providerDetail'] = providerDetail.toJson();
    return _data;
  }
}

class ProviderDetail {
  ProviderDetail({
    required this.id,
    required this.name,
    required this.serviceLists,
    required this.email,
    required this.userId,
    required this.phonenumber,
    required this.address,
    required this.addaAreas,
  });
  late final String id;
  late final String name;
  late final List<ServiceLists> serviceLists;
  late final String email;
  late final String userId;
  late final int phonenumber;
  late final List<Address> address;
  late final List<String>addaAreas;

  ProviderDetail.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    serviceLists = List.from(json['serviceLists']).map((e)=>ServiceLists.fromJson(e)).toList();
    email = json['email'];
    userId = json['userId'];
    phonenumber = json['phonenumber'];
    address = List.from(json['address']).map((e)=>Address.fromJson(e)).toList();
    addaAreas = List.castFrom<dynamic, String>(json['addaAreas']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['serviceLists'] = serviceLists.map((e)=>e.toJson()).toList();
    _data['email'] = email;
    _data['userId'] = userId;
    _data['phonenumber'] = phonenumber;
    _data['addaAreas'] = addaAreas;
    _data['address'] = address.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class ServiceLists {
  ServiceLists({
    required this.name,
    required this.subCategory,
    required this.price,
  });
  late final String name;
  late final List<SubCategory> subCategory;
  late final double price;

  ServiceLists.fromJson(Map<String, dynamic> json){
    name = json['name'];
    subCategory = List.from(json['subCategory']).map((e)=>SubCategory.fromJson(e)).toList();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['subCategory'] = subCategory.map((e)=>e.toJson()).toList();
    _data['price'] = price;
    return _data;
  }
}

class SubCategory {
  SubCategory({
    required this.name,
    required this.price,
  });
  late final String name;
  late final double price;

  SubCategory.fromJson(Map<String, dynamic> json){
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['price'] = price;
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