

import 'dart:convert';

List<NotificationResponse> notificationResponseFromJson(String str) =>
    List<NotificationResponse>.from(
        json.decode(str).map((x) => NotificationResponse.fromJson(x)));
String notificationResponseToJson(NotificationResponse data) =>
    json.encode(data.toJson());


class NotificationResponse {
  NotificationResponse({
    required this.bookingId,
    required this.message,
    required this.createTime,
    required this.id,
  });
  late final int bookingId;
  late final String message;
  late final String createTime;
  late final String id;

  NotificationResponse.fromJson(Map<String, dynamic> json){
    bookingId = json['bookingId'];
    message = json['message'];
    createTime = json['createTime'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bookingId'] = bookingId;
    _data['message'] = message;
    _data['createTime'] = createTime;
    _data['id'] = id;
    return _data;
  }
}