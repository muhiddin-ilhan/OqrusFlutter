// To parse this JSON data, do
//
//     final whyIncompleteReasonModel = whyIncompleteReasonModelFromJson(jsonString);

import 'dart:convert';

List<WhyIncompleteReasonModel> whyIncompleteReasonModelFromJson(String str) => List<WhyIncompleteReasonModel>.from(json.decode(str).map((x) => WhyIncompleteReasonModel.fromJson(x)));

String whyIncompleteReasonModelToJson(List<WhyIncompleteReasonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WhyIncompleteReasonModel {
  WhyIncompleteReasonModel({
    this.id,
    this.title,
    this.company,
  });

  int id;
  String title;
  Company company;

  factory WhyIncompleteReasonModel.fromJson(Map<String, dynamic> json) => WhyIncompleteReasonModel(
    id: json["Id"],
    title: json["Title"],
    company: Company.fromJson(json["Company"]),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Title": title,
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
  dynamic title;
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
