
import 'dart:convert';

RegisterResponseModel registerationResponseJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });
  late final String userId;
  late final String accessToken;
  late final String refreshToken;

  RegisterResponseModel.fromJson(Map<String, dynamic> json){
    userId = json['userId'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['accessToken'] = accessToken;
    _data['refreshToken'] = refreshToken;
    return _data;
  }
}