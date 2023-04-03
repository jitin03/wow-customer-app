class RegistrationRequest {
  RegistrationRequest({
     this.firstname,
     this.lastname,
     this.email,
     this.password,
     this.role,
     this.phonenumber,
  });
  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? role;
  String? phonenumber;

  RegistrationRequest.fromJson(Map<String, dynamic> json){
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['email'] = email;
    _data['password'] = password;
    _data['role'] = role;
    _data['phonenumber'] = phonenumber;
    return _data;
  }
}