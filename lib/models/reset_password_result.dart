import 'dart:convert';

ResetPasswordResult resetPasswordResultFromJson(String str) => ResetPasswordResult.fromJson(json.decode(str));

String resetPasswordResultToJson(ResetPasswordResult data) => json.encode(data.toJson());

class ResetPasswordResult {
  ResetPasswordResult({
    this.isSuccess,
  });

  bool isSuccess;

  factory ResetPasswordResult.fromJson(Map<String, dynamic> json) => ResetPasswordResult(
        isSuccess: json["IsSuccess"] == null ? null : json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess == null ? null : isSuccess,
      };
}
