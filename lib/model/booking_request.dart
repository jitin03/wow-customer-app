
import 'dart:convert';

String bookingRequestToJson(BookingRequest data) => json.encode(data.toJson());


class BookingRequest {
  BookingRequest({
     this.bookingAddress,
     this.bookingTime,
     this.customerId,
     this.grossAmount,
     this.paymentMode,
     this.paymentStatus,
     this.providerId,
     this.serviceLists,
     this.status,
  });
   String? bookingAddress;
   String? bookingTime;
   String? customerId;
   String? grossAmount;
   String? paymentMode;
   String? paymentStatus;
   String? providerId;
   List<ServiceLists>? serviceLists;
   String? status;

  BookingRequest.fromJson(Map<String, dynamic> json){
    bookingAddress = json['bookingAddress'];
    bookingTime = json['bookingTime'];
    customerId = json['customerId'];
    grossAmount = json['grossAmount'];
    paymentMode = json['paymentMode'];
    paymentStatus = json['paymentStatus'];
    providerId = json['providerId'];
    serviceLists = List.from(json['serviceLists']).map((e)=>ServiceLists.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bookingAddress'] = bookingAddress;
    _data['bookingTime'] = bookingTime;
    _data['customerId'] = customerId;
    _data['grossAmount'] = grossAmount;
    _data['paymentMode'] = paymentMode;
    _data['paymentStatus'] = paymentStatus;
    _data['providerId'] = providerId;
    _data['serviceLists'] = serviceLists!.map((e)=>e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class ServiceLists {
  ServiceLists({
     this.name,
     this.price,
     this.subCategories,
  });
   String? name;
   num? price;
   List<SubCategories>? subCategories;

  ServiceLists.fromJson(Map<String, dynamic> json){
    name = json['name'];
    price = json['price'];
    subCategories = List.from(json['subCategories']).map((e)=>SubCategories.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['price'] = price;
    _data['subCategories'] = subCategories!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SubCategories {
  SubCategories({
     this.count,
     this.name,
     this.price,
  });
   String? count;
   String? name;
   num? price;

  SubCategories.fromJson(Map<String, dynamic> json){
    count = json['count'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['name'] = name;
    _data['price'] = price;
    return _data;
  }
}