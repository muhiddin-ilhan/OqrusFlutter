import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:flutter_app/models/why_incomplete_reason_model.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/providers/WhyIncompleteTaskProvider.dart';
import 'package:flutter_app/providers/clicked_event_provider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _butonClicked = false;
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
  Widget build(BuildContext context) {
    AppLocalizations.of(context);
    final double topSafeSize = MediaQuery.of(context).padding.top;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.lightBlueAccent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark));
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: topSafeSize),
          height: height,
          color: Colors.lightBlueAccent,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.0075),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                          left: width * 0.03, top: height * 0.002),
                      width: width,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: width * 0.09,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: width,
                      alignment: Alignment.topCenter,
                      child: Text(
                        '${AppLocalizations.getString("page_title_detail_page")}',
                        style: TextStyle(
                            fontSize: width * 0.07,
                            fontFamily: 'SuezOne',
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08, vertical: height * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height * 0.05),
                      topLeft: Radius.circular(height * 0.05),
                    ),
                  ),
                  child: Consumer<ClickedEvent>(
                    builder: (context, clickedEventNesne, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.assignment,
                                size: width * 0.15,
                                color: Colors.grey[600],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Container(
                                          width: width * 0.6,
                                          child: Text(
                                              '${clickedEventNesne.title}',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.blue[900]))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: width * 0.025,
                                      ),
                                      Container(
                                        width: width * 0.6,
                                        child: Text(
                                          '${clickedEventNesne.allTaskInfo.taskTitle}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue[900]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Expanded(
                            flex: 50,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${AppLocalizations.getString("genel_bilgiler")}",
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Divider(height: height * 0.01, thickness: 1),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.room,
                                        size: width * 0.075,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        width: width * 0.75,
                                        child: Text(
                                          '${clickedEventNesne.getAddress()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: width * 0.075,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        width: width * 0.75,
                                        child: Text(
                                          '${clickedEventNesne.getStartTime()} - ${clickedEventNesne.getEndTime()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timelapse,
                                        size: width * 0.075,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        width: width * 0.75,
                                        child: Text(
                                          '${clickedEventNesne.getDuration()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.outlined_flag_rounded,
                                        size: width * 0.075,
                                        color: clickedEventNesne
                                                .isFuture()
                                                .contains("Yapılmış")
                                            ? Colors.green
                                            : clickedEventNesne
                                                    .isFuture()
                                                    .contains("Yapılmamış")
                                                ? Colors.red
                                                : clickedEventNesne
                                                        .isFuture()
                                                        .contains("Yapılamamış")
                                                    ? Colors.orange
                                                    : Colors.blue,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        width: width * 0.75,
                                        child: Text(
                                          '${clickedEventNesne.isFuture()}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: clickedEventNesne
                                                      .isFuture()
                                                      .contains("Yapılmış")
                                                  ? Colors.green
                                                  : clickedEventNesne
                                                          .isFuture()
                                                          .contains(
                                                              "Yapılmamış")
                                                      ? Colors.red
                                                      : clickedEventNesne
                                                              .isFuture()
                                                              .contains(
                                                                  "Yapılamamış")
                                                          ? Colors.orange
                                                          : Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    "${AppLocalizations.getString("gorev_tanimi")}",
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Divider(height: height * 0.01, thickness: 1),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        size: width * 0.075,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        width: width * 0.75,
                                        child: Text(
                                          clickedEventNesne.allTaskInfo
                                                  .taskDefinition.isNotEmpty
                                              ? '${clickedEventNesne.allTaskInfo.taskDefinition}'
                                              : '${AppLocalizations.getString("no_description")}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    "${AppLocalizations.getString("gorev_notu")}",
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Divider(height: height * 0.01, thickness: 1),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.event_note,
                                        size: width * 0.075,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Container(
                                        width: width * 0.75,
                                        child: Text(
                                          clickedEventNesne.allTaskInfo.taskNote
                                                  .isNotEmpty
                                              ? '${clickedEventNesne.allTaskInfo.taskNote}'
                                              : '${AppLocalizations.getString("no_note")}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  clickedEventNesne.getState() == 2
                                      ? Text(
                                          "${AppLocalizations.getString("gorev_yapmama_sebebi")}",
                                          style: TextStyle(
                                              color: Colors.lightBlue),
                                        )
                                      : SizedBox(),
                                  clickedEventNesne.getState() == 2
                                      ? Divider(
                                          height: height * 0.01, thickness: 1)
                                      : SizedBox(),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  clickedEventNesne.getState() == 2
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.description,
                                              size: width * 0.075,
                                              color: Colors.grey[600],
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Container(
                                              width: width * 0.75,
                                              child: Text(
                                                clickedEventNesne
                                                        .getIncompleteReason() ??
                                                    '${AppLocalizations.getString("no_note")}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: clickedEventNesne.getState() == 1
                                        ? Colors.red
                                        : clickedEventNesne.getState() == 2
                                            ? Colors.orange
                                            : Colors.green,
                                    width: 2,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(5)),
                            minWidth: width,
                            onPressed: () {
                              validDialog(context, clickedEventNesne.getState(),
                                  clickedEventNesne.getId());
                            },
                            child: _butonClicked
                                ? SizedBox(
                                    width: height * 0.02,
                                    height: height * 0.02,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3))
                                : Text(
                                    clickedEventNesne.getState() == 1
                                        ? "${AppLocalizations.getString("dont_finish_task")}"
                                        : clickedEventNesne.getState() == 2
                                            ? "${AppLocalizations.getString("durum_guncelle")}"
                                            : "${AppLocalizations.getString("finish_task")}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: clickedEventNesne.getState() == 1
                                            ? Colors.red
                                            : clickedEventNesne.getState() == 2
                                                ? Colors.orange
                                                : Colors.green),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  validDialog(context, taskState, timesId) {
    Dialogs.bottomMaterialDialog(
        msg: 'Görev Durumunu Ne Olarak Değiştirmek İstiyorsunuz ?',
        title:
            '${AppLocalizations.getString("task_state_change_dialog_title")}',
        context: context,
        actions: [
          taskState == 0
              ? IconsButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await showReasonDialog(context, timesId);
                  },
                  text: 'Yapamadım',
                  iconData: Icons.adjust_rounded,
                  color: Colors.orange,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                )
              : taskState == 1
                  ? IconsButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await showReasonDialog(context, timesId);
                      },
                      text: 'Yapamadım',
                      iconData: Icons.adjust_rounded,
                      color: Colors.orange,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    )
                  : IconsButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _updateTask(context, 0, timesId);
                      },
                      text: 'Yapılmadı',
                      iconData: Icons.cancel_outlined,
                      color: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    ),
          taskState == 0
              ? IconsButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateTask(context, 1, timesId);
                  },
                  text: 'Yapıldı',
                  iconData: Icons.check_outlined,
                  color: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                )
              : taskState == 1
                  ? IconsButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _updateTask(context, 0, timesId);
                      },
                      text: 'Yapılmadı',
                      iconData: Icons.cancel_outlined,
                      color: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    )
                  : IconsButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _updateTask(context, 1, timesId);
                      },
                      text: 'Yapıldı',
                      iconData: Icons.check_outlined,
                      color: Colors.green,
                      textStyle: TextStyle(color: Colors.white),
                      iconColor: Colors.white,
                    )
        ]);
  }

  _updateTask(context, taskState, timesId) async {
    setState(() {
      _butonClicked = true;
    });
    GetTaskResult thisEvent =
        Provider.of<ClickedEvent>(context, listen: false).allTaskInfo;

    TaskTime tmpTaskTime;
    for (TaskTime taskTime in thisEvent.taskTimes) {
      if (taskTime.id == timesId) {
        tmpTaskTime = taskTime;
      }
    }

    tmpTaskTime.state = taskState;

    await updateTask(thisEvent, tmpTaskTime, thisEvent.id, selectedItem)
        .then((value) async {
      if (value != null) {
        if (value.isSuccess) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          _getTask(prefs.getInt('user_id') ?? '', context);
        } else {
          setState(() {
            _butonClicked = false;
          });
        }
      } else {
        setState(() {
          _butonClicked = false;
        });
        showToast(
            context, '${AppLocalizations.getString("err_undefined_error")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
    return null;
  }

  Future<Map<DateTime, List>> _getTask(int userId, context) async {
    GetTask getTaskModel = GetTask(userId: userId);

    await getTask(getTaskModel).then((value) async {
      if (value != null) {
        Provider.of<EventsProvider>(context, listen: false).setEvents(value);
        setState(() {
          _butonClicked = false;
        });
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          _butonClicked = false;
        });
        showToast(
            context, '${AppLocalizations.getString("err_undefined_error")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
    return null;
  }

  showReasonDialog(BuildContext context, int timesId) {
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
                      _updateTask(context, 2, timesId);
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
