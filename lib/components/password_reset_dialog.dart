import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/global/validate_email.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/reset_password_model.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

passwordResetDialog(BuildContext context) {
  AppLocalizations.of(context);
  GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  TextEditingController _passResetEmailFieldController =
      TextEditingController();

  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          width: width * 0.8,
          height: height*0.28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(height * 0.05)),
          ),
          child: Padding(
            padding: EdgeInsets.all(height * 0.025),
            child: Form(
              key: _resetPasswordFormKey,
              child: Column(
                children: [
                  Text(
                    '${AppLocalizations.getString("sifre_sifirlama")}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: _passResetEmailFieldController,
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r' '))
                    ],
                    validator: (value) => value.isEmpty || !validateEmail(value)
                        ? '${AppLocalizations.getString("err_invalid_email")}'
                        : null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(height * 0.02),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(height * 0.025)),
                      ),
                      prefixIcon: Icon(Icons.mail),
                      labelText: "${AppLocalizations.getString("email")}",
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: height * 0.06,
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.deepOrange,
                            child: Text('${AppLocalizations.getString("vazgeç")}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width*0.05,),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: height * 0.06,
                          child: MaterialButton(
                            onPressed: () {
                              if (validateEmail(
                                  _passResetEmailFieldController.text)) {
                                var resetPasswordModel = ResetPasswordModel(identity: _passResetEmailFieldController.text);
                                resetPassword(context, resetPasswordModel).then((value) {
                                  if (value.isSuccess) {
                                    _passResetEmailFieldController.text = '';

                                    Navigator.pop(context);
                                    showToast(context,
                                        '${AppLocalizations.getString("sifre_sifirlama_mail")}',
                                        gravity: ToastGravity.TOP);
                                  } else {
                                    showToast(context,
                                        '${AppLocalizations.getString("bir_hata")}',
                                        gravity: ToastGravity.TOP);
                                  }
                                });
                                FocusScope.of(context).unfocus();
                              } else {
                                showToast(context, '${AppLocalizations.getString("err_invalid_email")}',
                                    gravity: ToastGravity.TOP);
                              }
                            },
                            color: Colors.blue,
                            child: Text(
                              '${AppLocalizations.getString("send")}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    ),
  );
}
