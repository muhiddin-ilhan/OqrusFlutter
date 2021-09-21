import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/report_page.dart';
import 'package:flutter_app/pages/splash_screen.dart';
import 'package:flutter_app/providers/WhyIncompleteTaskProvider.dart';
import 'package:flutter_app/providers/clicked_event_provider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/providers/takvim_son_kalinan_yer_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    var _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    // if (message.containsKey('data')) {
    //   // Handle data message
    //   final dynamic data = message['data'];
    // }
    //
    // if (message.containsKey('notification')) {
    //   // Handle notification message
    //   final dynamic notification = message['notification'];
    // }
    // Or do other work.
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.lightBlueAccent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark
    ));
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (context) => WhyIncompleteTaskProvider()),
        ChangeNotifierProvider(create: (context) => ClickedEvent()),
        ChangeNotifierProvider(create: (context) => EventsProvider()),
        ChangeNotifierProvider(create: (context) => TakvimSonKalinanYer()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'oQRus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        supportedLocales: [Locale("en"), Locale("tr")],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        home: SplashScreen()
      ),
    );
  }
}
