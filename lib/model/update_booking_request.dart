



class BookingStatusUpdateRequest {
  BookingStatusUpdateRequest({
    required this.status,
  });
  late final String status;

  BookingStatusUpdateRequest.fromJson(Map<String, dynamic> json){
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    return _data;
  }
}


class BookingPaymentUpdateRequest {
  BookingPaymentUpdateRequest({
    required this.paymentMode,
  });
  late final String paymentMode;

  BookingPaymentUpdateRequest.fromJson(Map<String, dynamic> json){
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['paymentMode'] = paymentMode;
    return _data;
  }
}