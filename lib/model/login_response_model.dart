
import 'dart:convert';

VerifyOtpResonseModel verifyOtpResponseJson(String str) =>
    VerifyOtpResonseModel.fromJson(json.decode(str));

class VerifyOtpResonseModel{
  VerifyOtpResonseModel({
    required this.userId,
    required this.jwt,
    required this.message,
    required this.status,
  });
  late final String userId;
  late final String jwt;
  late final String message;
  late final String status;

  VerifyOtpResonseModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    jwt = json['jwt'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['jwt'] = jwt;
    _data['message'] = message;
    _data['status'] = status;
    return _data;
  }
}