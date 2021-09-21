import 'dart:convert';

ResetPasswordModel resetPasswordModelFromJson(String str) => ResetPasswordModel.fromJson(json.decode(str));

String resetPasswordModelToJson(ResetPasswordModel data) => json.encode(data.toJson());

class ResetPasswordModel {
  ResetPasswordModel({
    this.identity,
  });

  String identity;

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) => ResetPasswordModel(
        identity: json["Identity"] == null ? null : json["Identity"],
      );

  Map<String, dynamic> toJson() => {
        "Identity": identity == null ? null : identity,
      };
}
