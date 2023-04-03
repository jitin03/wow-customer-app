
import 'dart:convert';

RequestOtpResponse requestOtpResponseFromJson(String str) => RequestOtpResponse.fromJson(json.decode(str));

String requestOtpResponseToJson(RequestOtpResponse data) => json.encode(data.toJson());

class RequestOtpResponse {
  RequestOtpResponse({
    required this.otp,
    required this.message,
    required this.status,
  });
  late final String otp;
  late final String message;
  late final String status;

  RequestOtpResponse.fromJson(Map<String, dynamic> json){
    otp = json['otp'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['otp'] = otp;
    _data['message'] = message;
    _data['status'] = status;
    return _data;
  }
}