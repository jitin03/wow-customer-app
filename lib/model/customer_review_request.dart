
import 'dart:convert';

String customerReviewRequestToJson(CustomerReviewRequest data) => json.encode(data.toJson());

class CustomerReviewRequest {
  CustomerReviewRequest({
     this.customerBookingId,
     this.customerId,
     this.providerId,
     this.rating,
     this.reviewMessage,
  });
   int? customerBookingId;
   String? customerId;
   String? providerId;
   String? rating;
   String? reviewMessage;

  CustomerReviewRequest.fromJson(Map<String, dynamic> json){
    customerBookingId = json['customerBookingId'];
    customerId = json['customerId'];
    providerId = json['providerId'];
    rating = json['rating'];
    reviewMessage = json['review_message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customerBookingId'] = customerBookingId;
    _data['customerId'] = customerId;
    _data['providerId'] = providerId;
    _data['rating'] = rating;
    _data['review_message'] = reviewMessage;
    return _data;
  }
}

String customerFeedbackRequestToJson(CustomerFeedbackRequest data) => json.encode(data.toJson());
class CustomerFeedbackRequest {
  CustomerFeedbackRequest({
    this.customerId,
    this.serviceArea,
    this.serviceDescription,
    this.serviceType,
  });
  int? customerBookingId;
  String? customerId;
  String? serviceArea;
  String? serviceDescription;
  String? serviceType;

  CustomerFeedbackRequest.fromJson(Map<String, dynamic> json){

    customerId = json['customerId'];
    serviceArea = json['serviceArea'];
    serviceDescription = json['serviceDescription'];
    serviceType = json['serviceType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};


    _data['customerId'] = customerId;
    _data['serviceArea'] = serviceArea;
    _data['serviceDescription'] = serviceDescription;
    _data['serviceType'] = serviceType;
    return _data;
  }
}