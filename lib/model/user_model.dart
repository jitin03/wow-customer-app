class UserModel {

  String? otp;
  String? phoneNo;

  UserModel({ this.otp, this.phoneNo});

  UserModel.fromJson(Map<String, dynamic> json) {

    otp = json['otp'];
    phoneNo = json['phoneNo'];
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'otp': otp?.trim(),
      'phoneNo': phoneNo?.trim(),
    };

    return map;
  }
}