import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/user_agreement_dialog.dart';
import 'package:flutter_app/global/cities.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/global/validate_email.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/register_model.dart';
import 'package:flutter_app/models/register_result.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _surnameFieldController = TextEditingController();
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();

  String _selectedCity;
  bool _hidePassword = true;
  bool userAgreement = false;
  bool _registerClicked = false;

  @override
  Widget build(BuildContext context) {
    AppLocalizations.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        return ;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Stack(
           children: [
             Container(
               alignment: Alignment.centerLeft,
               width: width,
               child: GestureDetector(
                 onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},
                 child: Icon(Icons.arrow_back, size: width*0.1),
               ),
             ),
             Container(
               alignment: Alignment.center,
               width: width,
               child: Text(
                 '${AppLocalizations.getString("kayit_ol")}',
                 style: TextStyle(fontSize: 28, fontFamily: 'SuezOne'),
               ),
             ),
           ],
          ),
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
        ),
        body: Container(
          color: Colors.lightBlueAccent,
          height: height,
          width: width,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(height * 0.04)),
                  color: Colors.white,
                ),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.06, height * 0.05, width * 0.06, height * 0.04),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            textAlignVertical: TextAlignVertical.center,
                            validator: (value) => value.isEmpty ? '${AppLocalizations.getString("err_cannot_be_blank")}' : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z ÇçĞğİıÖöŞşÜü]'))
                            ],
                            controller: _nameFieldController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(height * 0.02),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * 0.025)),
                              ),
                              prefixIcon: Icon(Icons.person),
                              labelText: '${AppLocalizations.getString("name")}',
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _surnameFieldController,
                            validator: (value) => value.isEmpty ? '${AppLocalizations.getString("err_cannot_be_blank")}' : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z ÇçĞğİıÖöŞşÜü]'))
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(height * 0.02),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * 0.025)),
                              ),
                              prefixIcon: Icon(Icons.person),
                              labelText: '${AppLocalizations.getString("surname")}',
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.027, top: height * 0.019),
                                child: Icon(
                                  Icons.home,
                                  size: 26,
                                  color: Colors.grey,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                validator: (value) =>
                                    value == null ? '${AppLocalizations.getString("select_city")}' : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.getString("city")}',
                                  labelStyle: TextStyle(fontSize: 18),
                                  contentPadding: EdgeInsets.only(
                                      top: height * 0.02,
                                      bottom: height * 0.02,
                                      left: width * 0.12,
                                      right: width * 0.04),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(height * 0.025),
                                    ),
                                  ),
                                ),
                                items: cities.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    _selectedCity = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: _emailFieldController,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value.isEmpty || !validateEmail(value)
                                ? '${AppLocalizations.getString("err_invalid_email")}'
                                : null,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r' '))
                            ],
                            onEditingComplete: () {
                              _emailFieldController.text =
                                  _emailFieldController.text.toLowerCase();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(height * 0.02),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * 0.025)),
                              ),
                              prefixIcon: Icon(Icons.email),
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
                                controller: _passwordFieldController,
                                textAlignVertical: TextAlignVertical.center,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return '${AppLocalizations.getString("err_cannot_be_blank")}';
                                  else if (!value.contains(new RegExp(r'[a-z]')) && !value.contains(new RegExp(r'[A-Z]')) ||
                                      !value.contains(new RegExp(r'[0-9]')))
                                    return '${AppLocalizations.getString("sifre_harf_ve_sayi")}';
                                  else if (value.length < 8) return '${AppLocalizations.getString("sifre_8_karakter")}';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(height * 0.02),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * 0.025)),
                                  ),
                                  prefixIcon: Icon(Icons.vpn_key),
                                  labelText: "${AppLocalizations.getString("password")}",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _hidePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
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
                              SizedBox(height: height * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    value: this.userAgreement,
                                    onChanged: (bool value) {
                                      setState(() {
                                        this.userAgreement = value;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      child: RichText(
                                        text: TextSpan(
                                          text: '${AppLocalizations.getString("kullanici_sozlesmesi")}',
                                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                          children: [
                                            TextSpan(
                                              text: '${AppLocalizations.getString("kullanici_sozlesmesi_2")}',
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        showUserAgreementDialog(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            height: height*0.06,
                            width: width*0.65,
                            child: MaterialButton(
                              onPressed: () {
                                if (!_registerClicked) _register();
                              },
                              color: Colors.blue,
                              child: _registerClicked
                                  ? SizedBox(width: width*0.05, height: width*0.05, child: CircularProgressIndicator(strokeWidth: 3, backgroundColor: Colors.white,))
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.create, color: Colors.white, size: height*0.025),
                                  SizedBox(width: 8),
                                  Text(
                                    '${AppLocalizations.getString("kayit_ol")}',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                                  ),
                                ],
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
      ),
    );
  }

  _register() async {
    if (_registerFormKey.currentState.validate() && !userAgreement) {
      showToast(context, '${AppLocalizations.getString("sozlesme_kontrolu")}', gravity: ToastGravity.TOP);
    } else if (_registerFormKey.currentState.validate()) {
      RegisterModel registerModel = RegisterModel(
        name: _nameFieldController.text,
        surName: _surnameFieldController.text,
        identity: _emailFieldController.text.toLowerCase(),
        password: _passwordFieldController.text,
        detail: Detail(cityName: _selectedCity),
      );

      // await showLoadingDialog(tapDismiss: false);
      setState(() {
        _registerClicked = true;
      });
      RegisterResult result = await register(context, registerModel);

      if (result != null && result.isSuccess) {
        showToast(context, '${AppLocalizations.getString("kayit_basarili")}',
            gravity: ToastGravity.BOTTOM, duration: Duration(seconds: 8));
      } else {
        showToast(context, result.resultMessage, gravity: ToastGravity.TOP);
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      setState(() {
        _registerClicked = false;
      });
    }
  }
}

