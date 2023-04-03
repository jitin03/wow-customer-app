
import 'dart:convert';

CreateBookingOrderResponse createOrderResponse(String str) =>
    CreateBookingOrderResponse.fromJson(json.decode(str));

class CreateBookingOrderResponse {
  final String? paymentSessionId;
  final String? orderStatus;
  final CustomerDetails? customerDetails;
  final String? orderId;
  final double? cfOrderId;

  CreateBookingOrderResponse({
    this.paymentSessionId,
    this.orderStatus,
    this.customerDetails,
    this.orderId,
    this.cfOrderId,
  });

  CreateBookingOrderResponse.fromJson(Map<String, dynamic> json)
      : paymentSessionId = json['payment_session_id'] as String?,
        orderStatus = json['order_status'] as String?,
        customerDetails = (json['customer_details'] as Map<String,dynamic>?) != null ? CustomerDetails.fromJson(json['customer_details'] as Map<String,dynamic>) : null,
        orderId = json['order_id'] as String?,
        cfOrderId = json['cf_order_id'] as double?;

  Map<String, dynamic> toJson() => {
    'payment_session_id' : paymentSessionId,
    'order_status' : orderStatus,
    'customer_details' : customerDetails?.toJson(),
    'order_id' : orderId,
    'cf_order_id' : cfOrderId
  };
}

class CustomerDetails {
  final String? customerId;
  final String? customerEmail;
  final String? customerPhone;

  CustomerDetails({
    this.customerId,
    this.customerEmail,
    this.customerPhone,
  });

  CustomerDetails.fromJson(Map<String, dynamic> json)
      : customerId = json['customer_id'] as String?,
        customerEmail = json['customer_email'] as String?,
        customerPhone = json['customer_phone'] as String?;

  Map<String, dynamic> toJson() => {
    'customer_id' : customerId,
    'customer_email' : customerEmail,
    'customer_phone' : customerPhone
  };
}