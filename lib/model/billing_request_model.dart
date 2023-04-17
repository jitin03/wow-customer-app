//
//
//
// import 'dart:convert';
//
// BillingRequest billingRequestFromJson(String str) => BillingRequest.fromJson(json.decode(str));
// //
// String billingRequestToJson(BillingRequest data) => json.encode(data.toJson());
//
// class BillingRequest {
//
//   String? customerId;
//   String? grossAmount;
//   String? providerId;
//   List<ServiceLists>? serviceLists;
//   String? status;
//
//   BillingRequest(
//       {
//         this.customerId,
//         this.grossAmount,
//         this.providerId,
//         this.serviceLists,
//         this.status});
//
//   BillingRequest.fromJson(Map<String, dynamic> json) {
//
//     customerId = json['customerId'];
//     grossAmount = json['grossAmount'];
//     providerId = json['providerId'];
//     if (json['serviceLists'] != null) {
//       serviceLists = <ServiceLists>[];
//       json['serviceLists'].forEach((v) {
//         serviceLists!.add(new ServiceLists.fromJson(v));
//       });
//     }
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//
//     data['customerId'] = this.customerId;
//     data['grossAmount'] = this.grossAmount;
//     data['providerId'] = this.providerId;
//     if (this.serviceLists != null) {
//       data['serviceLists'] = this.serviceLists!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class ServiceLists {
//   String? name;
//   double? price;
//   List<SubCategories>? subCategories;
//
//   ServiceLists({this.name, this.price, this.subCategories});
//
//   ServiceLists.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     price = json['price'];
//     if (json['subCategories'] != null) {
//       subCategories = <SubCategories>[];
//       json['subCategories'].forEach((v) {
//         subCategories!.add(new SubCategories.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['price'] = this.price;
//     if (this.subCategories != null) {
//       data['subCategories'] = this.subCategories!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SubCategories {
//   String? count;
//   String? name;
//   double? price;
//
//   SubCategories({this.count, this.name, this.price});
//
//   SubCategories.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     name = json['name'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['count'] = this.count;
//     data['name'] = this.name;
//     data['price'] = this.price;
//     return data;
//   }
// }