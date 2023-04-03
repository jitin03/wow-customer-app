import 'dart:convert';

List<BillingResponse> billingResponseFromJson(String str) =>
    List<BillingResponse>.from(
        json.decode(str).map((x) => BillingResponse.fromJson(x)));
//
String billingResponseToJson(BillingResponse data) =>
    json.encode(data.toJson());

class BillingResponse {
  BillingResponse({
    required this.serviceLists,
    required this.status,
    required this.grossAmount,
    required this.billingId,
    required this.customerId,
    required this.providerId,
    required this.providerName,
  });
  late final List<ServiceLists> serviceLists;
  late final String status;
  late final String grossAmount;
  late final String billingId;
  late final List<String> customerId;
  late final List<int> customerPhoneNo;
  late final List<String> customerEmail;
  late final List<String> providerId;
  late final List<String> providerName;

  BillingResponse.fromJson(Map<String, dynamic> json) {
    serviceLists = List.from(json['serviceLists'])
        .map((e) => ServiceLists.fromJson(e))
        .toList();
    status = json['status'];
    grossAmount = json['grossAmount'];
    billingId = json['billingId'];
    customerId = List.castFrom<dynamic, String>(json['customerId']);
    customerPhoneNo = List.castFrom<dynamic, int>(json['customerPhoneNo']);
    customerEmail = List.castFrom<dynamic, String>(json['customerEmail']);
    providerId = List.castFrom<dynamic, String>(json['providerId']);
    providerName = List.castFrom<dynamic, String>(json['providerName']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['serviceLists'] = serviceLists.map((e) => e.toJson()).toList();
    _data['status'] = status;
    _data['grossAmount'] = grossAmount;
    _data['billingId'] = billingId;
    _data['customerId'] = customerId;
    _data['customerPhoneNo'] = customerPhoneNo;
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
  late final double price;

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
  late final double price;
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
