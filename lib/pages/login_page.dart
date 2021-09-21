import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/password_reset_dialog.dart';
import 'package:flutter_app/global/check_connection.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/global/validate_email.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/models/login_model.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/providers/WhyIncompleteTaskProvider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _sharedPrefs = SharedPreferences.getInstance();
  SharedPreferences sharedPrefs;

  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();

  bool _hidePassword = true;
  bool isLoginButtonClicked = false;

  @override
  void initState() {
    super.initState();

    _sharedPrefs.then((SharedPreferences prefs) {
      sharedPrefs = prefs;
      _emailFieldController.text = prefs.getString('user_mail') ?? '';
      _passwordFieldController.text = prefs.getString('user_password') ?? '';
    });

    checkConnection().then((value) {
      if (!value) {
        showToast(context, '${AppLocalizations.getString("connection_control")}', gravity: ToastGravity.BOTTOM);
      }
    });
  }

  Future<bool> onBackPressed() async {
    Dialogs.bottomMaterialDialog(msg: '${AppLocalizations.getString("exit_dialog_msg")}', title: '${AppLocalizations.getString("exit_dialog_title")}', context: context, actions: [
      IconsButton(
        onPressed: () {
          Navigator.pop(context);
        },
        text: '${AppLocalizations.getString("dialog_answer_no")}',
        iconData: Icons.cancel_outlined,
        color: Colors.red,
        textStyle: TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
      IconsButton(
        onPressed: () {
          exit(0);
        },
        text: '${AppLocalizations.getString("dialog_answer_yes")}',
        iconData: Icons.check_circle_outline,
        color: Colors.lightBlueAccent,
        textStyle: TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
    ]);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations.of(context);
    final double topSafeSize = MediaQuery.of(context).padding.top;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.lightBlueAccent,
        systemNavigationBarColor: Colors.lightBlueAccent,
        systemNavigationBarDividerColor: Colors.lightBlueAccent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light
    ));
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(top: topSafeSize),
              color: Colors.lightBlueAccent,
              height: height,
              width: width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: height * 0.11),
                    child: Image.asset(
                      'assets/images/oqrusLogo.png',
                      width: width * 0.17,
                    ),
                  ),
                  Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(height * 0.03)),
                        elevation: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(height * 0.03)),
                            color: Colors.white,
                          ),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.06, height * 0.05, width * 0.06, height * 0.04),
                              child: Form(
                                key: _loginFormKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: _emailFieldController,
                                      keyboardType: TextInputType.emailAddress,
                                      textAlignVertical: TextAlignVertical.center,
                                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r' '))],
                                      validator: (value) => value.isEmpty ? '${AppLocalizations.getString("err_invalid_email")}' : null,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(height * 0.02),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(height * 0.015)),
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
                                      height: height * 0.03,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        TextFormField(
                                          textInputAction: TextInputAction.done,
                                          obscureText: _hidePassword,
                                          textAlignVertical: TextAlignVertical.center,
                                          controller: _passwordFieldController,
                                          validator: (value) => value.isEmpty ? '${AppLocalizations.getString("err_cannot_be_blank")}' : null,
                                          onFieldSubmitted: (_) => userLogin(),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(height * 0.02),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(height * 0.015)),
                                            ),
                                            prefixIcon: Icon(Icons.vpn_key),
                                            labelText: "${AppLocalizations.getString("password")}",
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _hidePassword ? Icons.visibility : Icons.visibility_off,
                                                color: Theme.of(context).primaryColorDark,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _hidePassword = !_hidePassword;
                                                });
                                              },
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        /*SizedBox(height: height * 0.015),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, height * 0.003, width * 0.01, 0),
                                          child: GestureDetector(
                                            onTap: () => passwordResetDialog(context),
                                            child: Text(
                                              '${AppLocalizations.getString("forgot_password")}',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    SizedBox(
                                      width: width * 0.67,
                                      height: height * 0.06,
                                      child: MaterialButton(
                                        onPressed: () async {
                                          if (!isLoginButtonClicked) await userLogin();
                                        },
                                        color: Colors.blue,
                                        elevation: 1,
                                        child: isLoginButtonClicked
                                            ? SizedBox(
                                                width: width * 0.05,
                                                height: width * 0.05,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  backgroundColor: Colors.white,
                                                ))
                                            : Text(
                                                '${AppLocalizations.getString("login")}',
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: width * 0.01, bottom: height * 0.005),
              alignment: Alignment.bottomRight,
              child: Text(
                '1.0.0',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blue[900]),
              ),
            )
          ],
        ),
      ),
    );
  }

  userLogin() async {
    if (_loginFormKey.currentState.validate()) {
      setState(() {
        isLoginButtonClicked = true;
      });

      LoginModel loginModel = LoginModel(identity: _emailFieldController.text.toLowerCase(), password: _passwordFieldController.text);

      await login(loginModel).then((value) async {
        print(value);
        if (value != null) {
          if (value.loginResult.isSuccess) {
            sharedPrefs.setString('user_mail', _emailFieldController.text ?? '');
            sharedPrefs.setString('user_password', _passwordFieldController.text ?? '');
            sharedPrefs.setInt('user_company_id', value.company.id ?? 0);
            sharedPrefs.setString('user_token', value.token ?? '');
            sharedPrefs.setInt('user_id', value.id ?? '');

            getTaskIncompleteReason();
            getTasksByUserId(value.id);
          } else {
            setState(() {
              isLoginButtonClicked = false;
            });
            if (value.loginResult.isSuccess != null && value.loginResult.isSuccess)
              showToast(context, '${AppLocalizations.getString("err_not_confirm_email")}', gravity: ToastGravity.BOTTOM, duration: Duration(seconds: 4));
            else if (value.loginResult.resultMessage != null && value.loginResult.resultMessage == '${AppLocalizations.getString("err_max_reach_entry")}')
              showToast(context,
                  '${AppLocalizations.getString("err_max_reach_entry_time")} ${value.leftTime} ${value.leftTime == 1 ? '${AppLocalizations.getString("minute")}' : '${AppLocalizations.getString("minute")}'}',
                  gravity: ToastGravity.TOP);
            else
              showToast(context, '${AppLocalizations.getString("err_wrong_mail_or_pass")}', gravity: ToastGravity.BOTTOM, duration: Duration(seconds: 4));
          }
        } else {
          setState(() {
            isLoginButtonClicked = false;
          });
          showToast(context, '${AppLocalizations.getString("err_undefined_error")}', gravity: ToastGravity.BOTTOM);
        }
      });
    }
  }

  getTasksByUserId(int userId) async {
    GetTask getTaskApiModel = GetTask(userId: userId);

    await getTask(getTaskApiModel).then((value) async {
      setState(() {
        isLoginButtonClicked = false;
      });

      if (value != null) {
        Provider.of<EventsProvider>(context, listen: false).setEvents(value);
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        showToast(context, '${AppLocalizations.getString("err_undefined_error")}', gravity: ToastGravity.BOTTOM);
      }
    });
    return null;
  }

  getTaskIncompleteReason() async {
    await getIncompleteReason().then((value) async {
      if (value != null) {
        Provider.of<WhyIncompleteTaskProvider>(context, listen: false).setReasons(value);
      }
    });
  }
}
