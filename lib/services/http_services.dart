import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/global/constants.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:flutter_app/models/login_model.dart';
import 'package:flutter_app/models/login_result.dart';
import 'package:flutter_app/models/register_model.dart';
import 'package:flutter_app/models/register_result.dart';
import 'package:flutter_app/models/reset_password_model.dart';
import 'package:flutter_app/models/reset_password_result.dart';
import 'package:flutter_app/models/update_task_result.dart';
import 'package:flutter_app/models/why_incomplete_reason_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<RegisterResult> register(
    BuildContext context, RegisterModel registerModel) async {
  var client = http.Client();
  String _json = json.encode(registerModel.toJson());
  try {
    var response = await client.post(
      '$BASE_API_URL/Authentication/RegisterUser',
      body: _json,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      Future.delayed(Duration(milliseconds: 200), () {
        showToast(context,
            'Bir Hata Meydana Geldi. Lütfen Daha Sonra Tekrar Deneyiniz');
      });
      return null;
    }

    // print(response.body);
    return registerResultFromJson(response.body);
  } finally {
    client.close();
  }
}

Future<LoginResult> login(LoginModel loginModel) async {
  var client = http.Client();
  String _json = json.encode(loginModel.toJson());
  try {
    var response = await client.post(
      '$BASE_API_URL/Authentication/Login',
      body: _json,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      return null;
    }

    return loginResultFromJson(response.body);
  } finally {
    client.close();
  }
}

Future<ResetPasswordResult> resetPassword(
    BuildContext context, ResetPasswordModel resetPasswordModel) async {
  var client = http.Client();
  String _json = json.encode(resetPasswordModel.toJson());
  try {
    var response = await client.post(
      '$BASE_API_URL/Authentication/ResetPassword',
      body: _json,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      Future.delayed(Duration(milliseconds: 200), () {
        showToast(context,
            'Bir hata meydana geldi. Lütfen daha sonra tekrar deneyiniz');
      });
      return null;
    }

    //print(response.body);
    return resetPasswordResultFromJson(response.body);
  } finally {
    client.close();
  }
}

Future<List<GetTaskResult>> getTask(GetTask getTask) async {
  var client = http.Client();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _json = json.encode(getTask.toJson());
  try {
    var response = await client.post(
      '$BASE_API_URL/Task/GetTasksByUserId',
      body: _json,
      headers: {
        'Content-Type': 'application/json',
        'Token': prefs.getString('user_token') ?? '',
      },
    );
    if (response.statusCode != 200) {
      return null;
    }

    return getTaskResultFromJson(response.body);
  } finally {
    client.close();
  }
}

Future<List<GetTaskResult>> getTaskByGuid(String qrValue) async {
  var client = http.Client();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['Guid'] = qrValue;
  String _json = json.encode(data);
  try {
    var response = await client.post(
      '$BASE_API_URL/Task/GetTasksByGuid',
      body: _json,
      headers: {
        'Content-Type': 'application/json',
        'Token': prefs.getString('user_token') ?? '',
      },
    );
    if (response.statusCode != 200) {
      return null;
    }

    return getTaskResultFromJson(response.body);
  } finally {
    client.close();
  }
}

Future<List<WhyIncompleteReasonModel>> getIncompleteReason() async {
  var client = http.Client();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> data = {
    "Company": {"Id": prefs.getInt("user_company_id")},
  };

  String _json = json.encode(data);
  try {
    var response = await client.post(
      '$BASE_API_URL/Task/GetIncompleteReasons',
      body: _json,
      headers: {
        'Content-Type': 'application/json',
        'Token': prefs.getString('user_token') ?? '',
      },
    );
    if (response.statusCode != 200) {
      return null;
    }

    return whyIncompleteReasonModelFromJson(response.body);
  } finally {
    client.close();
  }
}

Future<UpdateTaskResult> updateTask(GetTaskResult getTaskResult,
    TaskTime taskTime, int taskId, WhyIncompleteReasonModel sebepId) async {
  var client = http.Client();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, dynamic> body = {
    "Id": taskTime.id,
    "Task": {"Id": taskId},
    "StartDate": taskTime.startDate.toIso8601String(),
    "FinishDate": taskTime.finishDate.toIso8601String(),
    "Duration": taskTime.duration,
    "IsPeriodic": taskTime.isPeriodic,
    "HourPeriod": taskTime.hourPeriod,
    "State": taskTime.state,
    "Comment": "",
    "IncompleteReason": {"Id": sebepId == null ? 0 : sebepId.id}
  };

  print(body);

  String _json = json.encode(body);
  try {
    var response = await client.post(
      '$BASE_API_URL/Task/UpdateTaskTimes',
      body: _json,
      headers: {
        'Content-Type': 'application/json',
        'Token': prefs.getString('user_token') ?? '',
      },
    );
    if (response.statusCode != 200) {
      return null;
    }

    return updateTaskResultFromJson(response.body);
  } finally {
    client.close();
  }
}
