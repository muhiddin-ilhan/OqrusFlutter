// To parse this JSON data, do
//
//     final loginResult = loginResultFromJson(jsonString);

import 'dart:convert';

LoginResult loginResultFromJson(String str) => LoginResult.fromJson(json.decode(str));

String loginResultToJson(LoginResult data) => json.encode(data.toJson());

class LoginResult {
  LoginResult({
    this.id,
    this.identity,
    this.name,
    this.surName,
    this.loginResult,
    this.token,
    this.roles,
    this.leftTime,
    this.attemptNumber,
    this.dbUniqueKey,
    this.territoryId,
    this.isDeleted,
    this.company,
  });

  int id;
  String identity;
  String name;
  String surName;
  LoginResultClass loginResult;
  String token;
  List<Role> roles;
  int leftTime;
  int attemptNumber;
  dynamic dbUniqueKey;
  int territoryId;
  int isDeleted;
  Company company;

  factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
    id: json["Id"],
    identity: json["Identity"],
    name: json["Name"],
    surName: json["SurName"],
    loginResult: LoginResultClass.fromJson(json["LoginResult"]),
    token: json["Token"],
    roles: json["Roles"] != null ? List<Role>.from(json["Roles"].map((x) => Role.fromJson(x))): null,
    leftTime: json["LeftTime"],
    attemptNumber: json["AttemptNumber"],
    dbUniqueKey: json["DbUniqueKey"],
    territoryId: json["TerritoryId"],
    isDeleted: json["IsDeleted"],
    company: json["Company"] != null ? Company.fromJson(json["Company"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Identity": identity,
    "Name": name,
    "SurName": surName,
    "LoginResult": loginResult.toJson(),
    "Token": token,
    "Roles": List<dynamic>.from(roles.map((x) => x.toJson())),
    "LeftTime": leftTime,
    "AttemptNumber": attemptNumber,
    "DbUniqueKey": dbUniqueKey,
    "TerritoryId": territoryId,
    "IsDeleted": isDeleted,
    "Company": company.toJson(),
  };
}

class Company {
  Company({
    this.id,
    this.title,
    this.isActive,
    this.isDeleted,
  });

  int id;
  String title;
  int isActive;
  int isDeleted;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["Id"],
    title: json["Title"],
    isActive: json["IsActive"],
    isDeleted: json["IsDeleted"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Title": title,
    "IsActive": isActive,
    "IsDeleted": isDeleted,
  };
}

class LoginResultClass {
  LoginResultClass({
    this.isSuccess,
    this.resultMessage
  });

  bool isSuccess;
  String resultMessage;

  factory LoginResultClass.fromJson(Map<String, dynamic> json) => LoginResultClass(
    isSuccess: json["IsSuccess"],
    resultMessage: json["ResultMessage"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "IsSuccess": isSuccess,
    "ResultMessage": resultMessage
  };
}

class Role {
  Role({
    this.id,
    this.title,
    this.description,
    this.scopeType,
    this.roleAuthortities,
    this.company,
  });

  int id;
  String title;
  dynamic description;
  int scopeType;
  List<RoleAuthortity> roleAuthortities;
  Company company;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["Id"],
    title: json["Title"],
    description: json["Description"],
    scopeType: json["ScopeType"],
    roleAuthortities: List<RoleAuthortity>.from(json["RoleAuthortities"].map((x) => RoleAuthortity.fromJson(x))),
    company: Company.fromJson(json["Company"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Title": title,
    "Description": description,
    "ScopeType": scopeType,
    "RoleAuthortities": List<dynamic>.from(roleAuthortities.map((x) => x.toJson())),
    "Company": company.toJson(),
  };
}

class RoleAuthortity {
  RoleAuthortity({
    this.id,
    this.name,
    this.description,
  });

  int id;
  String name;
  String description;

  factory RoleAuthortity.fromJson(Map<String, dynamic> json) => RoleAuthortity(
    id: json["Id"],
    name: json["Name"],
    description: json["Description"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "Description": description,
  };
}
