class LoginModel {
  String identity;
  String password;

  LoginModel({this.identity, this.password});

  LoginModel.fromJson(Map<String, dynamic> json) {
    identity = json['Identity'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Identity'] = this.identity;
    data['Password'] = this.password;
    return data;
  }
}
