


import 'dart:convert';


// List<CustomerReviewsResponse> decodeReviews(String jsonString) {
//   final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
//   return parsed.map<CustomerReviewsResponse>((json) => CustomerReviewsResponse.fromJson(json)).toList();
// }
List<CustomerReviewsResponse> customerReviewsResponseFromJson(String str) =>
    List<CustomerReviewsResponse>.from(
        json.decode(str).map((x) => CustomerReviewsResponse.fromJson(x)));
String customerReviewsResponseToJson(CustomerReviewsResponse data) =>
    json.encode(data.toJson());
class CustomerReviewsResponse {
  String? id;
  CustomerProfile? customerProfile;
  ProviderDetail? providerDetail;
  String? reviewMessage;
  String? createDate;
  String? rating;

  CustomerReviewsResponse(
      {this.id,
        this.customerProfile,
        this.providerDetail,
        this.reviewMessage,
        this.createDate,
        this.rating});

  CustomerReviewsResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerProfile = json['customerProfile'] != null
        ? new CustomerProfile.fromJson(json['customerProfile'])
        : null;
    providerDetail = json['providerDetail'] != null
        ? new ProviderDetail.fromJson(json['providerDetail'])
        : null;
    reviewMessage = json['review_message'];
    createDate = json['createDate'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.customerProfile != null) {
      data['customerProfile'] = this.customerProfile!.toJson();
    }
    if (this.providerDetail != null) {
      data['providerDetail'] = this.providerDetail!.toJson();
    }
    data['review_message'] = this.reviewMessage;
    data['createDate'] = this.createDate;
    data['rating'] = this.rating;
    return data;
  }
}

class CustomerProfile {
  String? name;
  String? id;
  String? emailaddress;
  String? userId;
  int? phonenumber;
  int? age;
  String? gender;
  Address? address;

  CustomerProfile(
      {this.name,
        this.id,
        this.emailaddress,
        this.userId,
        this.phonenumber,
        this.age,
        this.gender,
        this.address});

  CustomerProfile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    emailaddress = json['emailaddress'];
    userId = json['userId'];
    phonenumber = json['phonenumber'];
    age = json['age'];
    gender = json['gender'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['emailaddress'] = this.emailaddress;
    data['userId'] = this.userId;
    data['phonenumber'] = this.phonenumber;
    data['age'] = this.age;
    data['gender'] = this.gender;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  String? address1;
  String? address2;
  String? city;
  String? pincode;
  String? state;

  Address({this.address1, this.address2, this.city, this.pincode, this.state});

  Address.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    return data;
  }
}

class ProviderDetail {
  String? id;
  List<ServiceLists>? serviceLists;
  String? name;
  int? phonenumber;
  String? email;
  String? userId;
  List<Address>? address;

  ProviderDetail(
      {this.id,
        this.serviceLists,
        this.name,
        this.phonenumber,
        this.email,
        this.userId,
        this.address});

  ProviderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['serviceLists'] != null) {
      serviceLists = <ServiceLists>[];
      json['serviceLists'].forEach((v) {
        serviceLists!.add(new ServiceLists.fromJson(v));
      });
    }
    name = json['name'];
    phonenumber = json['phonenumber'];
    email = json['email'];
    userId = json['userId'];
    if (json['address'] != null) {
      address = <Address>[];
      json['address'].forEach((v) {
        address!.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.serviceLists != null) {
      data['serviceLists'] = this.serviceLists!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['phonenumber'] = this.phonenumber;
    data['email'] = this.email;
    data['userId'] = this.userId;
    if (this.address != null) {
      data['address'] = this.address!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceLists {
  String? name;
  List<SubCategory>? subCategory;
  double? price;

  ServiceLists({this.name, this.subCategory, this.price});

  ServiceLists.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['subCategory'] != null) {
      subCategory = <SubCategory>[];
      json['subCategory'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.subCategory != null) {
      data['subCategory'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    return data;
  }
}

class SubCategory {
  String? name;
  double? price;

  SubCategory({this.name, this.price});

  SubCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}





// class CustomerReviewsResponse {
//   CustomerReviewsResponse({
//     required this.createDate,
//     required this.customerProfile,
//     required this.id,
//     required this.providerDetail,
//     required this.rating,
//     required this.reviewMessage,
//   });
//   late final String createDate;
//   late final CustomerProfile customerProfile;
//   late final String id;
//   late final ProviderDetail providerDetail;
//   late final int rating;
//   late final String reviewMessage;
//
//   CustomerReviewsResponse.fromJson(Map<String, dynamic> json){
//     createDate = json['createDate'];
//     customerProfile = CustomerProfile.fromJson(json['customerProfile']);
//     id = json['id'];
//     providerDetail = ProviderDetail.fromJson(json['providerDetail']);
//     rating = json['rating'];
//     reviewMessage = json['review_message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['createDate'] = createDate;
//     _data['customerProfile'] = customerProfile.toJson();
//     _data['id'] = id;
//     _data['providerDetail'] = providerDetail.toJson();
//     _data['rating'] = rating;
//     _data['review_message'] = reviewMessage;
//     return _data;
//   }
// }
//
// class CustomerProfile {
//   CustomerProfile({
//     required this.address,
//     required this.age,
//     required this.emailaddress,
//     required this.gender,
//     required this.id,
//     required this.name,
//     required this.phonenumber,
//     required this.userId,
//   });
//   late final Address address;
//   late final int age;
//   late final String emailaddress;
//   late final String gender;
//   late final String id;
//   late final String name;
//   late final int phonenumber;
//   late final String userId;
//
//   CustomerProfile.fromJson(Map<String, dynamic> json){
//     address = Address.fromJson(json['address']);
//     age = json['age'];
//     emailaddress = json['emailaddress'];
//     gender = json['gender'];
//     id = json['id'];
//     name = json['name'];
//     phonenumber = json['phonenumber'];
//     userId = json['userId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['address'] = address.toJson();
//     _data['age'] = age;
//     _data['emailaddress'] = emailaddress;
//     _data['gender'] = gender;
//     _data['id'] = id;
//     _data['name'] = name;
//     _data['phonenumber'] = phonenumber;
//     _data['userId'] = userId;
//     return _data;
//   }
// }
//
// class Address {
//   Address({
//     required this.address1,
//     required this.address2,
//     required this.city,
//     required this.pincode,
//     required this.state,
//   });
//   late final String address1;
//   late final String address2;
//   late final String city;
//   late final String pincode;
//   late final String state;
//
//   Address.fromJson(Map<String, dynamic> json){
//     address1 = json['address1'];
//     address2 = json['address2'];
//     city = json['city'];
//     pincode = json['pincode'];
//     state = json['state'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['address1'] = address1;
//     _data['address2'] = address2;
//     _data['city'] = city;
//     _data['pincode'] = pincode;
//     _data['state'] = state;
//     return _data;
//   }
// }
//
// class ProviderDetail {
//   ProviderDetail({
//     required this.addaAreas,
//     required this.address,
//     required this.email,
//     required this.id,
//     required this.name,
//     required this.phonenumber,
//     required this.serviceLists,
//     required this.userId,
//   });
//   late final List<String> addaAreas;
//   late final List<Address> address;
//   late final String email;
//   late final String id;
//   late final String name;
//   late final int phonenumber;
//   late final List<ServiceLists> serviceLists;
//   late final String userId;
//
//   ProviderDetail.fromJson(Map<String, dynamic> json){
//     addaAreas = List.castFrom<dynamic, String>(json['addaAreas']);
//     address = List.from(json['address']).map((e)=>Address.fromJson(e)).toList();
//     email = json['email'];
//     id = json['id'];
//     name = json['name'];
//     phonenumber = json['phonenumber'];
//     serviceLists = List.from(json['serviceLists']).map((e)=>ServiceLists.fromJson(e)).toList();
//     userId = json['userId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['addaAreas'] = addaAreas;
//     _data['address'] = address.map((e)=>e.toJson()).toList();
//     _data['email'] = email;
//     _data['id'] = id;
//     _data['name'] = name;
//     _data['phonenumber'] = phonenumber;
//     _data['serviceLists'] = serviceLists.map((e)=>e.toJson()).toList();
//     _data['userId'] = userId;
//     return _data;
//   }
// }
//
// class ServiceLists {
//   ServiceLists({
//     required this.name,
//     required this.price,
//     required this.subCategories,
//   });
//   late final String name;
//   late final int price;
//   late final List<SubCategories> subCategories;
//
//   ServiceLists.fromJson(Map<String, dynamic> json){
//     name = json['name'];
//     price = json['price'];
//     subCategories = List.from(json['subCategories']).map((e)=>SubCategories.fromJson(e)).toList();
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['name'] = name;
//     _data['price'] = price;
//     _data['subCategories'] = subCategories.map((e)=>e.toJson()).toList();
//     return _data;
//   }
// }
//
// class SubCategories {
//   SubCategories({
//     required this.count,
//     required this.name,
//     required this.price,
//   });
//   late final String count;
//   late final String name;
//   late final int price;
//
//   SubCategories.fromJson(Map<String, dynamic> json){
//     count = json['count'];
//     name = json['name'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['count'] = count;
//     _data['name'] = name;
//     _data['price'] = price;
//     return _data;
//   }
// }