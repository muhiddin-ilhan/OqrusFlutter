import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/events_model.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:flutter_app/models/why_incomplete_reason_model.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/providers/WhyIncompleteTaskProvider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskSelectPage extends StatefulWidget {
  @override
  _TaskSelectPageState createState() => _TaskSelectPageState();
}

class _TaskSelectPageState extends State<TaskSelectPage>
    with SingleTickerProviderStateMixin {
  DateTime day = DateTime.now();
  String dayTitle = "";
  Map<DateTime, List> _events;
  List _showingEvents;
  int selectedId = -1;
  EventModel selectedEvent;
  double _cardListOpacity = 1;
  double _cardListChangeOpacity = 1;
  AnimationController _animationController;
  bool isLoading = false;
  TextEditingController _whyNotCompleteTextController = TextEditingController();

  WhyIncompleteReasonModel selectedItem;
  List<DropdownMenuItem<WhyIncompleteReasonModel>> _dropdownMenuItems;
  List<WhyIncompleteReasonModel> reasons;

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
  void initState() {
    super.initState();
    reasons = Provider.of<WhyIncompleteTaskProvider>(context, listen: false)
        .getReasons();
    _dropdownMenuItems = buildDropDownMenuItems(reasons);
    selectedItem =
        _dropdownMenuItems.length > 0 ? _dropdownMenuItems[0].value : null;

    _events = Provider.of<EventsProvider>(context, listen: false).getQrEvents();

    List tmp = _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
    tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
    setState(() {
      _showingEvents = tmp ?? [];
      dayTitle = DateFormat("d MMMM y", "tr").format(day);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    Dialogs.bottomMaterialDialog(
        msg: '${AppLocalizations.getString("task_select_cancel_dialog_msg")}',
        title:
            '${AppLocalizations.getString("task_select_cancel_dialog_title")}',
        context: context,
        actions: [
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
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
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Container(
            //Title Ekranı Containerı.
            padding: EdgeInsets.only(top: topSafeSize),
            height: height,
            color: Colors.lightBlueAccent,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.0075),
                  child: sayfaBasligi(height, width),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(height * 0.05),
                        topLeft: Radius.circular(height * 0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: height * 0.1,
                            ),
                            GestureDetector(
                              onTap: () {
                                cardListRightLeftClick(false);
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                size: width * 0.15,
                                color: Colors.blue,
                              ),
                            ),
                            Spacer(),
                            AnimatedOpacity(
                              opacity: _cardListOpacity,
                              duration: Duration(milliseconds: 200),
                              child: AnimatedOpacity(
                                opacity: _cardListChangeOpacity,
                                duration: Duration(milliseconds: 200),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    '$dayTitle',
                                    style: TextStyle(
                                        color: Colors.blue[900], fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                day.isAfter(DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)) ||
                                        day.isAtSameMomentAs(DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day))
                                    ? showToast(context,
                                        '${AppLocalizations.getString("future_task_cannot_visible")}',
                                        gravity: ToastGravity.BOTTOM)
                                    : cardListRightLeftClick(true);
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: width * 0.15,
                                color: day.isAfter(DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day)) ||
                                        day.isAtSameMomentAs(DateTime.utc(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day))
                                    ? Colors.black
                                    : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Center(
                                child: Consumer<EventsProvider>(
                                  builder: (context, epNesne, child) {
                                    return Dismissible(
                                      resizeDuration: null,
                                      onDismissed:
                                          (DismissDirection direction) {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          day.isAfter(DateTime.utc(
                                                      DateTime.now().year,
                                                      DateTime.now().month,
                                                      DateTime.now().day)) ||
                                                  day.isAtSameMomentAs(
                                                      DateTime.utc(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day))
                                              ? showToast(context,
                                                  '${AppLocalizations.getString("future_task_cannot_visible")}',
                                                  gravity: ToastGravity.BOTTOM,
                                                  duration:
                                                      Duration(seconds: 2))
                                              : setState(() {
                                                  dayTitle = DateFormat(
                                                          "d MMMM y",
                                                          Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .languageCode)
                                                      .format(day.add(
                                                          Duration(days: 1)));
                                                  day = day
                                                      .add(Duration(days: 1));
                                                  List tmp = _events[
                                                          DateTime.utc(
                                                              day.year,
                                                              day.month,
                                                              day.day)] ??
                                                      [];
                                                  tmp.sort((a, b) =>
                                                      a.dateTimeStart.compareTo(
                                                          b.dateTimeStart));
                                                  _showingEvents = tmp ?? [];
                                                });
                                        } else {
                                          setState(() {
                                            dayTitle = DateFormat(
                                                    "d MMMM y",
                                                    Localizations.localeOf(
                                                            context)
                                                        .languageCode)
                                                .format(day.subtract(
                                                    Duration(days: 1)));
                                            day =
                                                day.subtract(Duration(days: 1));
                                            List tmp = _events[DateTime.utc(
                                                    day.year,
                                                    day.month,
                                                    day.day)] ??
                                                [];
                                            tmp.sort((a, b) => a.dateTimeStart
                                                .compareTo(b.dateTimeStart));
                                            _showingEvents = tmp ?? [];
                                          });
                                        }
                                      },
                                      key: UniqueKey(),
                                      child: eventListeleme(height, width),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  validDialog(EventModel event) {
    Dialogs.bottomMaterialDialog(
        msg: '${AppLocalizations.getString("task_complete_dialog_msg")}',
        title:
            '${AppLocalizations.getString("task_state_change_dialog_title")}',
        context: context,
        actions: [
          IconsButton(
            onPressed: () {
              setState(() {
                selectedId = -1;
              });
              Navigator.pop(context);
            },
            text: 'Kapat',
            iconData: Icons.clear,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () {
              showReasonDialog(context, event);
            },
            text: 'Yapmadım',
            iconData: Icons.cancel_outlined,
            color: Colors.orange,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
          IconsButton(
            onPressed: () {
              Navigator.pop(context);
              onCompleteTask(event, 1);
            },
            text: 'Yaptım',
            iconData: Icons.check_outlined,
            color: Colors.green,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void onCompleteTask(event, taskState) async {
    setState(() {
      isLoading = true;
    });
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
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
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
        setState(() {
          isLoading = false;
        });
        Provider.of<EventsProvider>(context, listen: false).setEvents(value);
        showToast(context,
            '${AppLocalizations.getString("task_complete_successfully")}',
            gravity: ToastGravity.BOTTOM);
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        setState(() {
          isLoading = false;
        });
        showToast(
            context, '${AppLocalizations.getString("err_undefined_error")}',
            gravity: ToastGravity.BOTTOM);
      }
    });
    return null;
  }

  void cardListRightLeftClick(bool isRight) {
    int i = 1;
    DateTime tmpday = day;
    DateTime today = DateTime.now();
    if (isRight) {
      while (true) {
        tmpday = tmpday.add(Duration(days: 1));
        List tmp =
            _events[DateTime.utc(tmpday.year, tmpday.month, tmpday.day)] ?? [];
        if (tmp.isNotEmpty) {
          setState(() {
            _cardListChangeOpacity = 0;
          });
          Future.delayed(Duration(milliseconds: 200)).then((_) {
            setState(() {
              _cardListChangeOpacity = 1;
              dayTitle = DateFormat(
                      "d MMMM y", Localizations.localeOf(context).languageCode)
                  .format(day.add(Duration(days: i)));
              day = day.add(Duration(days: i));
              List tmp =
                  _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
              tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
              _showingEvents = tmp ?? [];
            });
          });
          break;
        }

        if (i == 30) {
          break;
        }
        if (DateTime.utc(tmpday.year, tmpday.month, tmpday.day)
            .isAtSameMomentAs(
                DateTime.utc(today.year, today.month, today.day))) {
          setState(() {
            _cardListChangeOpacity = 0;
          });
          Future.delayed(Duration(milliseconds: 200)).then((_) {
            setState(() {
              _cardListChangeOpacity = 1;
              dayTitle = DateFormat(
                      "d MMMM y", Localizations.localeOf(context).languageCode)
                  .format(day.add(Duration(days: i)));
              day = day.add(Duration(days: i));
              List tmp =
                  _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
              tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
              _showingEvents = tmp ?? [];
            });
          });
          break;
        }
        i++;
      }
    } else {
      while (true) {
        tmpday = tmpday.subtract(Duration(days: 1));
        List tmp =
            _events[DateTime.utc(tmpday.year, tmpday.month, tmpday.day)] ?? [];
        if (tmp.isNotEmpty) {
          setState(() {
            _cardListChangeOpacity = 0;
          });
          Future.delayed(Duration(milliseconds: 200)).then((_) {
            setState(() {
              _cardListChangeOpacity = 1;
              dayTitle = DateFormat(
                      "d MMMM y", Localizations.localeOf(context).languageCode)
                  .format(day.subtract(Duration(days: i)));
              day = day.subtract(Duration(days: i));
              List tmp =
                  _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
              tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
              _showingEvents = tmp ?? [];
            });
          });
          break;
        }
        i++;
        if (i == 30) {
          showToast(context, 'Geçmiş Göreviniz Bulunmuyor',
              gravity: ToastGravity.BOTTOM);
          break;
        }
      }
    }
  }

  Widget eventListeleme(double height, double width) {
    return _showingEvents.isEmpty
        ? Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: height * 0.035),
            child: Text(
              "${AppLocalizations.getString("no_task_for_today")}",
              style: TextStyle(
                  fontSize: width * 0.045,
                  color: Colors.black,
                  fontFamily: 'SuezOne'),
            ),
          )
        : AnimatedOpacity(
            opacity: _cardListOpacity,
            duration: Duration(milliseconds: 200),
            child: AnimatedOpacity(
              opacity: _cardListChangeOpacity,
              duration: Duration(milliseconds: 200),
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: _showingEvents
                    .map(
                      (event) => Stack(
                        children: [
                          ListTile(
                            onTap: () {
                              setState(() {
                                selectedId = event.getTaskId();
                              });
                              validDialog(event);
                            },
                            title: Material(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height * 0.02)),
                              elevation:
                                  selectedId == event.getTaskId() ? 5 : 2,
                              child: Container(
                                  padding: EdgeInsets.only(
                                    bottom: height * 0.012,
                                    top: height * 0.012,
                                    left: width * 0.03,
                                    right: width * 0.03,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedId != event.getTaskId()
                                        ? Color.fromRGBO(250, 250, 250, 1)
                                        : Color.fromRGBO(240, 240, 240, 1),
                                    border: Border.all(
                                        width: 1,
                                        color: selectedId != event.getTaskId()
                                            ? Colors.blue.withOpacity(0.75)
                                            : Colors.blue[900]),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * 0.02)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Yuvarlak Fotoğraf Alanı
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: width * 0.12,
                                            height: width * 0.12,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.2,
                                                  color: Colors.redAccent),
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.06)),
                                            ),
                                            child: Text(
                                              '${event.getType().toString().substring(0, 1)}',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: width * 0.05,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SuezOne'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${event.getType()}',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[900]),
                                          ),
                                          SizedBox(
                                            height: height * 0.004,
                                          ),
                                          Text(
                                            '${event.getTaskSmallTitle()}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue[700]),
                                          ),
                                          SizedBox(
                                            width: width * 0.68,
                                            height: height * 0.025,
                                            child: Center(
                                              child: Divider(
                                                color: Colors.blue[900],
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.query_builder,
                                                size: width * 0.04,
                                                color: Colors.blue[900],
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              Text(
                                                '${event.getDateTimeStart()}',
                                                style: TextStyle(
                                                    color: Colors.blue[900]
                                                        .withOpacity(0.6),
                                                    fontSize: 13),
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              Text(
                                                '- ${event.getDateTimeEnd()}',
                                                style: TextStyle(
                                                    color: Colors.blue[900]
                                                        .withOpacity(0.6),
                                                    fontSize: 13),
                                              ),
                                              SizedBox(
                                                width: width * 0.05,
                                              ),
                                              Icon(
                                                Icons.timer,
                                                size: width * 0.04,
                                                color: Colors.blue[900],
                                              ),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              Text(
                                                '${event.getDuration()}',
                                                style: TextStyle(
                                                    color: Colors.blue[900]
                                                        .withOpacity(0.6),
                                                    fontSize: 13),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          );
  }

  Widget sayfaBasligi(double height, double width) {
    return Stack(
      children: [
        GestureDetector(
            onTap: () {
              _onBackPressed();
            },
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: height * 0.002),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: width * 0.09,
              ),
            )),
        Container(
          width: width,
          alignment: Alignment.topCenter,
          child: Text(
            '${AppLocalizations.getString("page_title_choice_task")}',
            style: TextStyle(
                fontSize: width * 0.07,
                fontFamily: 'SuezOne',
                color: Colors.white),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: height * 0.011, right: width * 0.03),
          alignment: Alignment.topRight,
          child: isLoading
              ? SizedBox(
                  width: width * 0.065,
                  height: width * 0.065,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    backgroundColor: Colors.white,
                  ))
              : SizedBox(),
        )
      ],
    );
  }

  showReasonDialog(BuildContext context, EventModel event) {
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
                      onCompleteTask(event, 2);
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
