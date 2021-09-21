class RegisterModel {
  String identity;
  String name;
  String surName;
  String password;
  Detail detail;

  RegisterModel({this.identity, this.name, this.surName, this.password, this.detail});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    identity = json['Identity'];
    name = json['Name'];
    surName = json['SurName'];
    password = json['Password'];
    detail = json['Detail'] != null ? new Detail.fromJson(json['Detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Identity'] = this.identity;
    data['Name'] = this.name;
    data['SurName'] = this.surName;
    data['Password'] = this.password;
    if (this.detail != null) {
      data['Detail'] = this.detail.toJson();
    }
    return data;
  }
}

class Detail {
  String cityName;

  Detail({this.cityName});

  Detail.fromJson(Map<String, dynamic> json) {
    cityName = json['CityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CityName'] = this.cityName;
    return data;
  }
}
