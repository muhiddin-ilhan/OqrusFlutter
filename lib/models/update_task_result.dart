import 'dart:convert';

UpdateTaskResult updateTaskResultFromJson(String str) => UpdateTaskResult.fromJson(json.decode(str));

String updateTaskResultToJson(UpdateTaskResult data) => json.encode(data.toJson());

class UpdateTaskResult {
  UpdateTaskResult({
    this.isSuccess,
  });

  bool isSuccess;

  factory UpdateTaskResult.fromJson(Map<String, dynamic> json) => UpdateTaskResult(
    isSuccess: json["IsSuccess"] == null ? null : json["IsSuccess"],
  );

  Map<String, dynamic> toJson() => {
    "IsSuccess": isSuccess == null ? null : isSuccess,
  };
}