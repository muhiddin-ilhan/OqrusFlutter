import 'dart:convert';

RegisterResult registerResultFromJson(String str) => RegisterResult.fromJson(json.decode(str));

String registerResultToJson(RegisterResult data) => json.encode(data.toJson());

class RegisterResult {
  RegisterResult({
    this.isSuccess,
    this.resultMessage,
  });

  bool isSuccess;
  String resultMessage;

  factory RegisterResult.fromJson(Map<String, dynamic> json) => RegisterResult(
        isSuccess: json["IsSuccess"],
        resultMessage: json["ResultMessage"],
      );

  Map<String, dynamic> toJson() => {
        "IsSuccess": isSuccess,
        "ResultMessage": resultMessage,
      };
}
