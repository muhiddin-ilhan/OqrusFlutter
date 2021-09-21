import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/events_model.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:flutter_app/models/why_incomplete_reason_model.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/task_select_page.dart';
import 'package:flutter_app/providers/WhyIncompleteTaskProvider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOpen = false;
  String qrResult = "";
  QRViewController controller;
  int sensitivity = 10;
  int qrIndex = 0;
  TextEditingController _whyNotCompleteTextController = TextEditingController();

  WhyIncompleteReasonModel selectedItem;
  List<DropdownMenuItem<WhyIncompleteReasonModel>> _dropdownMenuItems;
  List<WhyIncompleteReasonModel> reasons;

  @override
  void initState() {
    super.initState();
    reasons = Provider.of<WhyIncompleteTaskProvider>(context, listen: false)
        .getReasons();
    _dropdownMenuItems = buildDropDownMenuItems(reasons);
    selectedItem =
        _dropdownMenuItems.length > 0 ? _dropdownMenuItems[0].value : null;
  }

  List<DropdownMenuItem<WhyIncompleteReasonModel>> buildDropDownMenuItems(
      List Reasons) {
    List<DropdownMenuItem<WhyIncompleteReasonModel>> items = List();
    for (WhyIncompleteReasonModel Reason in Reasons) {
      items.add(
        DropdownMenuItem(
          child: Text(Reason.title),
          value: Reason,
        ),
      );
    }
    return items;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black12,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));
    final double topSafeSize = MediaQuery.of(context).padding.top;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(height * 0.05),
                  topLeft: Radius.circular(height * 0.05),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            controller.flipCamera();
                          },
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                              borderRadius: height * 0.05,
                              borderColor: Colors.blue,
                              borderWidth: height * 0.01,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.1),
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () {
                              controller.stopCamera();
                              controller.dispose();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            },
                            child: Icon(
                              Icons.clear,
                              size: width * 0.2,
                              color: Colors.blue.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              controller.toggleFlash();
                              setState(() {
                                isFlashOpen == false
                                    ? isFlashOpen = true
                                    : isFlashOpen = false;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: height * 0.1),
                              child: isFlashOpen == false
                                  ? Icon(Icons.flash_on,
                                      size: height * 0.1,
                                      color: Colors.blue.withOpacity(0.6))
                                  : Icon(Icons.flash_off,
                                      size: height * 0.1,
                                      color: Colors.blue.withOpacity(0.6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      controller.stopCamera();

      await Vibration.vibrate(duration: 200);

      qrResult = scanData.code;
      if (qrResult
          .contains("https://ankaraofis.basarsoft.com.tr/oQRus/survey/")) {
        qrResult = qrResult.substring(49);
        print(qrResult);
        getTasks(qrResult);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        showToast(context, '${AppLocalizations.getString("wrong_qr_code_msg")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  getTasks(String qrValue) async {
    await getTaskByGuid(qrValue).then((value) async {
      if (value.length > 0) {
        await Provider.of<EventsProvider>(context, listen: false)
            .setEventsByGuid(value);
        Map<DateTime, List> tmpQr =
            Provider.of<EventsProvider>(context, listen: false).getQrEvents();
        aktifGorevVarmi(tmpQr);
      } else {
        showToast(
            context, '${AppLocalizations.getString("err_undefined_error")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
    return false;
  }

  aktifGorevVarmi(Map<DateTime, List> tmpQr) {
    DateTime day = DateTime.now();
    List taskList = tmpQr[DateTime.utc(day.year, day.month, day.day)] ?? [];
    EventModel tmpEventModel;
    int i = 0;
    for (int j = 0; j < 31; j++) {
      for (EventModel task in taskList) {
        if (task.getDateStart().isBefore(day) &&
            task.getDateEnd().isAfter(day)) {
          if (task.state == 0) {
            tmpEventModel = task;
            i = i + 1;
            if (i == 2) {
              break;
            }
          }
        }
      }
      day = day.subtract(Duration(days: 1));
      taskList = tmpQr[DateTime.utc(day.year, day.month, day.day)] ?? [];
    }

    if (i == 1) {
      Dialogs.bottomMaterialDialog(
          msg:
              '${tmpEventModel.getDateTimeStart() + " ile " + tmpEventModel.getDateTimeEnd() + " Zamanları Arasındaki " + tmpEventModel.getTaskSmallTitle() + " Başlıklı Görevi Onaylamak İstiyor musunuz?"}',
          title: '${tmpEventModel.type}',
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => TaskSelectPage()));
              },
              text: 'Tümünü Gör',
              iconData: Icons.margin,
              color: Colors.red,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              onPressed: () {
                showReasonDialog(context, tmpEventModel);
              },
              text: 'Yapmadım',
              iconData: Icons.cancel_outlined,
              color: Colors.orange,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              onPressed: () {
                onCompleteTask(tmpEventModel, 1);
              },
              text: 'Yaptım',
              iconData: Icons.check_circle_outline,
              color: Colors.green,
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ]);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TaskSelectPage()));
    }
  }

  void onCompleteTask(event, taskState) async {
    GetTaskResult getTaskResult = event.getTaskAllInfo();
    TaskTime taskTime = event.getTaskTime(event.getTaskId());
    int taskId = event.getTaskAllInfo().id;

    taskTime.state = taskState;

    await updateTask(getTaskResult, taskTime, taskId, selectedItem)
        .then((value) async {
      if (value != null) {
        if (value.isSuccess) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _getTask(prefs.getInt('user_id') ?? '', context);
        }
      } else {
        showToast(
            context, '${AppLocalizations.getString("err_undefined_error")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
  }

  Future<Map<DateTime, List>> _getTask(int userId, context) async {
    GetTask getTaskModel = GetTask(userId: userId);

    await getTask(getTaskModel).then((value) async {
      if (value != null) {
        Provider.of<EventsProvider>(context, listen: false).setEvents(value);
        showToast(context,
            '${AppLocalizations.getString("task_complete_successfully")}',
            gravity: ToastGravity.BOTTOM);
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        showToast(
            context, '${AppLocalizations.getString("err_undefined_error")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
    return null;
  }

  showReasonDialog(BuildContext context, EventModel tmpEventModel) {
    if (selectedItem != null) {
      return showDialog(
          context: context,
          builder: (dialogContext) {
            return StatefulBuilder(builder: (dialogContext, setState) {
              return AlertDialog(
                title: Text('Sebep'),
                content: DropdownButton<WhyIncompleteReasonModel>(
                  value: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                  items: _dropdownMenuItems,
                ),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text(
                      'İptal',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      _whyNotCompleteTextController.clear();
                      Navigator.pop(dialogContext);
                    },
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text(
                      'Tamamla',
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      onCompleteTask(tmpEventModel, 2);
                    },
                  ),
                ],
              );
            });
          });
    } else {
      showToast(context, 'Yöneticiniz Seçenek Eklememiş',
          gravity: ToastGravity.BOTTOM);
    }
  }
}
