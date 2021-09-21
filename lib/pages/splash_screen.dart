import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/models/login_model.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/providers/WhyIncompleteTaskProvider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> _sharedPrefs = SharedPreferences.getInstance();
  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();

    _sharedPrefs.then((SharedPreferences prefs) {
      sharedPrefs = prefs;
    });

    userLogin();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.lightBlueAccent,
        systemNavigationBarColor: Colors.lightBlueAccent,
        systemNavigationBarDividerColor: Colors.lightBlueAccent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.lightBlueAccent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/oqrusLogo.png',
                    width: width * 0.3,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: height*0.05),
              child: Text("Başarsoft", style: TextStyle(color: Colors.blue[700], fontSize: 20),),
            ),
          )
        ],
      ),
    );
  }

  userLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('user_mail') ?? "";
    String password = prefs.getString("user_password") ?? "";

    if (userName == "" || password == "") {
      goLoginPage();
    } else {
      LoginModel loginModel = LoginModel(identity: userName, password: password);

      await login(loginModel).then((value) async {
        if (value != null) {
          if (value.loginResult.isSuccess) {
            sharedPrefs.setString('user_token', value.token ?? '');
            sharedPrefs.setInt('user_id', value.id ?? '');

            getTaskIncompleteReason();
            reloadTasks(value.id ?? -1);
          } else {
            goLoginPage();
          }
        } else {
          goLoginPage();
        }
      });
    }
  }

  void reloadTasks(int userId) async {
    if (userId != -1) {
      getTasksByUserId(userId);
    } else {
      goLoginPage();
    }
  }

  getTaskIncompleteReason() async {
    await getIncompleteReason().then((value) async {
      if (value != null) {
        Provider.of<WhyIncompleteTaskProvider>(context, listen: false).setReasons(value);
      }
    });
  }

  getTasksByUserId(int userId) async {
    GetTask getTaskApiModel = GetTask(userId: userId);

    await getTask(getTaskApiModel).then((value) async {
      if (value != null) {
        Provider.of<EventsProvider>(context, listen: false).setEvents(value);
        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        goLoginPage();
      }
    });

    return null;
  }

  goLoginPage() async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
