// To parse this JSON data, do
//
//     final getTaskResult = getTaskResultFromJson(jsonString);

import 'dart:convert';

List<GetTaskResult> getTaskResultFromJson(String str) =>
    List<GetTaskResult>.from(
        json.decode(str).map((x) => GetTaskResult.fromJson(x)));

String getTaskResultToJson(List<GetTaskResult> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTaskResult {
  GetTaskResult({
    this.id,
    this.taskTitle,
    this.taskDefinition,
    this.taskNote,
    this.user,
    this.taskType,
    this.taskTimes,
    this.qrDefinitions,
    this.places,
    this.company,
    this.isDeleted,
    this.taskRule,
    this.recordDate,
  });

  int id;
  String taskTitle;
  String taskDefinition;
  String taskNote;
  User user;
  TaskType taskType;
  List<TaskTime> taskTimes;
  QrDefinitions qrDefinitions;
  List<Place> places;
  Company company;
  int isDeleted;
  String taskRule;
  DateTime recordDate;

  factory GetTaskResult.fromJson(Map<String, dynamic> json) => GetTaskResult(
        id: json["Id"],
        taskTitle: json["TaskTitle"],
        taskDefinition: json["TaskDefinition"],
        taskNote: json["TaskNote"],
        user: User.fromJson(json["User"]),
        taskType: TaskType.fromJson(json["TaskType"]),
        taskTimes: List<TaskTime>.from(
            json["TaskTimes"].map((x) => TaskTime.fromJson(x))),
        qrDefinitions: QrDefinitions.fromJson(json["QrDefinitions"]),
        places: List<Place>.from(json["Places"].map((x) => Place.fromJson(x))),
        company: Company.fromJson(json["Company"]),
        isDeleted: json["IsDeleted"],
        taskRule: json["TaskRule"],
        recordDate: DateTime.parse(json["RecordDate"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TaskTitle": taskTitle,
        "TaskDefinition": taskDefinition,
        "TaskNote": taskNote,
        "User": user.toJson(),
        "TaskType": taskType.toJson(),
        "TaskTimes": List<dynamic>.from(taskTimes.map((x) => x.toJson())),
        "QrDefinitions": qrDefinitions.toJson(),
        "Places": List<dynamic>.from(places.map((x) => x.toJson())),
        "Company": company.toJson(),
        "IsDeleted": isDeleted,
        "TaskRule": taskRule,
        "RecordDate": recordDate.toIso8601String(),
      };
}

class Company {
  Company({
    this.id,
    this.title,
    this.isActive,
    this.isDeleted,
    this.recordDate,
  });

  int id;
  String title;
  int isActive;
  int isDeleted;
  DateTime recordDate;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["Id"],
        title: json["Title"],
        isActive: json["IsActive"],
        isDeleted: json["IsDeleted"],
        recordDate: DateTime.parse(json["RecordDate"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Title": title,
        "IsActive": isActive,
        "IsDeleted": isDeleted,
        "RecordDate": recordDate.toIso8601String(),
      };
}

class Place {
  Place({
    this.id,
    this.placeTitle,
    this.parentPlaceId,
  });

  int id;
  String placeTitle;
  int parentPlaceId;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json["Id"],
        placeTitle: json["PlaceTitle"] == null ? null : json["PlaceTitle"],
        parentPlaceId: json["ParentPlaceId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PlaceTitle": placeTitle == null ? null : placeTitle,
        "ParentPlaceId": parentPlaceId,
      };
}

class QrDefinitions {
  QrDefinitions({
    this.id,
    this.guid,
    this.title,
    this.place,
    this.isDeleted,
  });

  int id;
  String guid;
  String title;
  Place place;
  int isDeleted;

  factory QrDefinitions.fromJson(Map<String, dynamic> json) => QrDefinitions(
        id: json["Id"],
        guid: json["Guid"],
        title: json["Title"],
        place: Place.fromJson(json["Place"]),
        isDeleted: json["IsDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Guid": guid,
        "Title": title,
        "Place": place.toJson(),
        "IsDeleted": isDeleted,
      };
}

class TaskTime {
  TaskTime({
    this.id,
    this.startDate,
    this.finishDate,
    this.duration,
    this.isPeriodic,
    this.hourPeriod,
    this.state,
    this.completionTime,
    this.comment,
    this.incompleteReason,
  });

  int id;
  DateTime startDate;
  DateTime finishDate;
  double duration;
  int isPeriodic;
  double hourPeriod;
  int state;
  DateTime completionTime;
  String comment;
  IncompleteReason incompleteReason;

  factory TaskTime.fromJson(Map<String, dynamic> json) => TaskTime(
        id: json["Id"],
        startDate: DateTime.parse(json["StartDate"]),
        finishDate: DateTime.parse(json["FinishDate"]),
        duration: json["Duration"],
        isPeriodic: json["IsPeriodic"],
        hourPeriod: json["HourPeriod"],
        state: json["State"],
        completionTime: DateTime.parse(json["CompletionTime"]),
        comment: json["Comment"] == null ? null : json["Comment"],
        incompleteReason: IncompleteReason.fromJson(json["IncompleteReason"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StartDate": startDate.toIso8601String(),
        "FinishDate": finishDate.toIso8601String(),
        "Duration": duration,
        "IsPeriodic": isPeriodic,
        "HourPeriod": hourPeriod,
        "State": state,
        "CompletionTime": completionTime.toIso8601String(),
        "Comment": comment == null ? null : comment,
        "IncompleteReason": incompleteReason.toJson(),
      };
}

class IncompleteReason {
  IncompleteReason({
    this.id,
    this.title,
    this.company,
  });

  int id;
  String title;
  dynamic company;

  factory IncompleteReason.fromJson(Map<String, dynamic> json) =>
      IncompleteReason(
        id: json["Id"],
        title: json["Title"],
        company: json["Company"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Title": title,
        "Company": company,
      };
}

class TaskType {
  TaskType({
    this.id,
    this.typeTitle,
    this.isDeleted,
  });

  int id;
  String typeTitle;
  int isDeleted;

  factory TaskType.fromJson(Map<String, dynamic> json) => TaskType(
        id: json["Id"],
        typeTitle: json["TypeTitle"],
        isDeleted: json["IsDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TypeTitle": typeTitle,
        "IsDeleted": isDeleted,
      };
}

class User {
  User({
    this.id,
    this.userName,
    this.name,
    this.surName,
    this.leftTime,
    this.attemptNumber,
    this.dbUniqueKey,
    this.territoryId,
    this.isDeleted,
  });

  int id;
  String userName;
  String name;
  String surName;
  int leftTime;
  int attemptNumber;
  dynamic dbUniqueKey;
  int territoryId;
  int isDeleted;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["Id"],
        userName: json["UserName"],
        name: json["Name"],
        surName: json["SurName"],
        leftTime: json["LeftTime"],
        attemptNumber: json["AttemptNumber"],
        dbUniqueKey: json["DbUniqueKey"],
        territoryId: json["TerritoryId"],
        isDeleted: json["IsDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "UserName": userName,
        "Name": name,
        "SurName": surName,
        "LeftTime": leftTime,
        "AttemptNumber": attemptNumber,
        "DbUniqueKey": dbUniqueKey,
        "TerritoryId": territoryId,
        "IsDeleted": isDeleted,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
