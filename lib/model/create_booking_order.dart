
import 'dart:convert';

String createBookingOrderToJson(CreateBookingOrder data) => json.encode(data.toJson());

class CreateBookingOrder {
   CustomerDetails? customerDetails;
   double? orderAmount;
   String? orderCurrency;
   String? orderNote;

  CreateBookingOrder({
    this.customerDetails,
    this.orderAmount,
    this.orderCurrency,
    this.orderNote,
  });

  CreateBookingOrder.fromJson(Map<String, dynamic> json)
      : customerDetails = (json['customer_details'] as Map<String,dynamic>?) != null ? CustomerDetails.fromJson(json['customer_details'] as Map<String,dynamic>) : null,
        orderAmount = json['order_amount'] as double?,
        orderCurrency = json['order_currency'] as String?,
        orderNote = json['order_note'] as String?;

  Map<String, dynamic> toJson() => {
    'customer_details' : customerDetails?.toJson(),
    'order_amount' : orderAmount,
    'order_currency' : orderCurrency,
    'order_note' : orderNote
  };
}

class CustomerDetails {
    String? customerEmail;
    String? customerId;
    String? customerPhone;

  CustomerDetails({
    this.customerEmail,
    this.customerId,
    this.customerPhone,
  });

  CustomerDetails.fromJson(Map<String, dynamic> json)
      : customerEmail = json['customer_email'] as String?,
        customerId = json['customer_id'] as String?,
        customerPhone = json['customer_phone'] as String?;

  Map<String, dynamic> toJson() => {
    'customer_email' : customerEmail,
    'customer_id' : customerId,
    'customer_phone' : customerPhone
  };
}