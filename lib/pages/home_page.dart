import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/global/toast.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/events_model.dart';
import 'package:flutter_app/models/get_task_model.dart';
import 'package:flutter_app/pages/detail_page.dart';
import 'package:flutter_app/pages/qr_code_page.dart';
import 'package:flutter_app/pages/report_page.dart';
import 'package:flutter_app/providers/clicked_event_provider.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:flutter_app/providers/takvim_son_kalinan_yer_provider.dart';
import 'package:flutter_app/services/http_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  SharedPreferences sharedPrefs;
  Map<DateTime, List> userTasks;
  CalendarController calendarController;
  AnimationController animationController;
  List selectedDayTasks;
  DateTime tiklananDay = DateTime.now();
  bool isCalendarVisible = true;
  String clickedDayDateTitle = "";
  double calendarOpacity = 1;
  double cardListOpacity = 0;
  double cardListNextOpacity = 1;

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();

    EventsProvider eventsProvider = Provider.of<EventsProvider>(context, listen: false);
    userTasks = eventsProvider.getEvents();
    eventsProvider.eventFilter("all", 0);

    TakvimSonKalinanYer mainPageLastPosition = Provider.of<TakvimSonKalinanYer>(context, listen: false);

    tiklananDay = mainPageLastPosition.getTiklananDay();
    List lastSelectedDayTasks = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
    lastSelectedDayTasks.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
    lastSelectedDayTasks.sort((a, b) => a.state.compareTo(b.state));

    setState(() {
      tiklananDay = mainPageLastPosition.getTiklananDay();
      isCalendarVisible = mainPageLastPosition.getIsCalendarVisible();
      clickedDayDateTitle = mainPageLastPosition.getTiklananDayTarihBaslik();
      cardListOpacity = mainPageLastPosition.getCardListOpacity();
      calendarOpacity = mainPageLastPosition.getCalendarOpacity();
      selectedDayTasks = lastSelectedDayTasks ?? [];
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    calendarController.dispose();
    animationController.dispose();
    super.dispose();
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
      //Geri Tuşunu Control Etme Widgeti.
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          //Title Ekranı Containerı.
          padding: EdgeInsets.only(top: topSafeSize),
          height: height,
          color: Colors.lightBlueAccent,
          child: Column(
            children: [
              pageTitleWidget(height, width),
              Expanded(
                child: Container(
                  //Beyaz Background Ekranı Containeri.
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height * 0.05),
                      topLeft: Radius.circular(height * 0.05),
                    ),
                  ),
                  child: Column(
                    children: [
                      calendarWidget(height, width),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Consumer<EventsProvider>(
                              builder: (context, epNesne, child) {
                                return Dismissible(
                                  resizeDuration: null,
                                  onDismissed: (DismissDirection direction) {
                                    direction == DismissDirection.endToStart
                                        ? setState(() {
                                            clickedDayDateTitle = DateFormat("d MMMM y", Localizations.localeOf(context).languageCode).format(tiklananDay.add(Duration(days: 1)));
                                            tiklananDay = tiklananDay.add(Duration(days: 1));
                                            List selectedDayUserTasks = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
                                            selectedDayUserTasks.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
                                            selectedDayUserTasks.sort((a, b) => a.state.compareTo(b.state));
                                            selectedDayTasks = selectedDayUserTasks ?? [];
                                          })
                                        : setState(() {
                                            clickedDayDateTitle = DateFormat("d MMMM y", Localizations.localeOf(context).languageCode).format(tiklananDay.subtract(Duration(days: 1)));
                                            tiklananDay = tiklananDay.subtract(Duration(days: 1));
                                            List selectedDayUserTasks = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
                                            selectedDayUserTasks.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
                                            selectedDayUserTasks.sort((a, b) => a.state.compareTo(b.state));
                                            selectedDayTasks = selectedDayUserTasks ?? [];
                                          });
                                  },
                                  key: UniqueKey(),
                                  child: tasksListWidget(height, width),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width * 0.07, bottom: height * 0.015),
                              child: FloatingActionButton(
                                backgroundColor: Colors.orange,
                                onPressed: () {
                                  TakvimSonKalinanYer tSKY = Provider.of<TakvimSonKalinanYer>(context, listen: false);
                                  tSKY.setValues(tiklananDay, isCalendarVisible, clickedDayDateTitle, selectedDayTasks, calendarOpacity, cardListOpacity);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QrCodePage()));
                                },
                                child: Image.asset(
                                  'assets/images/qrcode.png',
                                  width: width * 0.075,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ********* QR KOD BUTONU END ************ //
                      SizedBox(
                        height: height * 0.025,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageTitleWidget(double height, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.0075),
      child: Stack(
        children: [
          GestureDetector(
              onTap: () {
                !isCalendarVisible ? _onBackPressed() : _onLogoutButton();
              },
              child: !isCalendarVisible
                  ? Padding(
                      padding: EdgeInsets.only(left: width * 0.03, top: height * 0.002),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: width * 0.09,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: width * 0.04, top: height * 0.004),
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: width * 0.08,
                      ),
                    ),),
          GestureDetector(
              onTap: () async {
                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReportPage()));
              },
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.15, top: height * 0.002),
                child: Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: width * 0.09,
                ),
              ),
          ),
          Container(
            width: width,
            alignment: Alignment.topCenter,
            child: Text(
              isCalendarVisible ? '${AppLocalizations.getString("page_title_home_page")}' : '${AppLocalizations.getString("page_title_detail_page")}',
              style: TextStyle(fontSize: width * 0.07, fontFamily: 'SuezOne', color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              reloadTasks();
            },
            child: Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: width * 0.13, top: height * 0.003),
                child: Icon(
                  Icons.wifi_protected_setup,
                  color: Colors.white,
                  size: width * 0.08,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              filterTypeDialog(context);
            },
            child: Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: width * 0.03, top: height * 0.003),
                child: Icon(
                  Icons.filter_list_alt,
                  color: Colors.white,
                  size: width * 0.08,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget calendarWidget(double height, double width) {
    return isCalendarVisible
        ? AnimatedOpacity(
            opacity: calendarOpacity,
            duration: Duration(milliseconds: 300),
            child: Consumer<EventsProvider>(
              builder: (context, epNesne, child) {
                return TableCalendar(
                  calendarController: calendarController,
                  locale: '${AppLocalizations.getString("takvim_dil")}',
                  events: epNesne.getEvents(),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  initialCalendarFormat: CalendarFormat.month,
                  formatAnimation: FormatAnimation.slide,
                  onHeaderTapped: _onHeaderTapped,
                  onDaySelected: _onDaySelected,
                  initialSelectedDay: tiklananDay,
                  calendarStyle: CalendarStyle(
                    selectedColor: Colors.blue[400],
                    todayColor: Colors.blue[200],
                    markersColor: Colors.orange,
                    outsideDaysVisible: false,
                    weekendStyle: TextStyle().copyWith(color: Colors.blue[400]),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekendStyle: TextStyle().copyWith(color: Colors.blue[400]),
                    weekdayStyle: TextStyle().copyWith(color: Colors.blue[800]),
                  ),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.blue[900]),
                    headerMargin: EdgeInsets.only(bottom: height * 0.005, top: height * 0.005),
                  ),
                  builders: CalendarBuilders(markersBuilder: (context, date, events, holidays) {
                    final children = <Widget>[];
                    if (events.isNotEmpty) {
                      children.add(
                        calendarTaskCountMarker(date, events),
                      );
                    }
                    return children;
                  }),
                );
              },
            ),
          )
        : AnimatedOpacity(
            opacity: cardListOpacity,
            duration: Duration(milliseconds: 300),
            child: Row(
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
                  opacity: cardListNextOpacity,
                  duration: Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () {
                      takvimGosterGizle();
                    },
                    child: Text(
                      '$clickedDayDateTitle',
                      style: TextStyle(color: Colors.blue[900], fontSize: 20),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    cardListRightLeftClick(true);
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: width * 0.15,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          );
  }

  Widget calendarTaskCountMarker(DateTime date, List events) {
    DateTime today = DateTime.now();
    int unCompleted = 0;
    int total = 0;
    bool isFuture = false;
    if (date.isAfter(today)) {
      isFuture = true;
    } else {
      isFuture = false;
    }
    for (EventModel e in events) {
      total = total + 1;
      if (e.state == 0) {
        unCompleted = unCompleted + 1;
      }
    }
    return Container(
        child: total > 0
            ? Positioned(
                right: 1,
                bottom: 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          width: 1,
                          color: isFuture
                              ? unCompleted > 0 ? Colors.lightBlueAccent : Colors.green
                              : unCompleted > 0
                                  ? Colors.red[300]
                                  : Colors.green[300]),
                    ),
                    width: 17.0,
                    height: 17.0,
                    child: unCompleted > 0
                        ? Center(
                            child: Text(
                              '$unCompleted',
                              style: TextStyle().copyWith(
                                fontWeight: FontWeight.w500,
                                color: isFuture ? Colors.lightBlueAccent : Colors.red[400],
                                fontSize: 13.0,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                              size: 13,
                            ),
                          )),
              )
            : SizedBox());
  }

  Widget tasksListWidget(double height, double width) {
    DateTime today = DateTime.now();
    return selectedDayTasks.isEmpty && !isCalendarVisible
        ? Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: height * 0.035),
            child: Text(
              "${AppLocalizations.getString("no_task_for_today")}",
              style: TextStyle(fontSize: width * 0.045, color: Colors.black, fontFamily: 'SuezOne'),
            ),
          )
        : ListView(
            padding: EdgeInsets.only(top: 0),
            children: selectedDayTasks
                .map(
                  (event) => isCalendarVisible
                      ? SizedBox()
                      : AnimatedOpacity(
                          opacity: cardListOpacity,
                          duration: Duration(milliseconds: 300),
                          child: AnimatedOpacity(
                            opacity: cardListNextOpacity,
                            duration: Duration(milliseconds: 200),
                            child: Consumer<ClickedEvent>(
                              builder: (context, clickedEventNesne, child) {
                                return Stack(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        listEventClick(clickedEventNesne, event);
                                      },
                                      title: Material(
                                        borderRadius: BorderRadius.all(Radius.circular(height * 0.02)),
                                        elevation: 2,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: height * 0.012,
                                            top: height * 0.012,
                                            left: width * 0.03,
                                            right: width * 0.03,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(250, 250, 250, 1),
                                            border: Border.all(width: 1, color: Colors.blue.withOpacity(0.75)),
                                            borderRadius: BorderRadius.all(Radius.circular(height * 0.02)),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          color: event.getDateEnd().isAfter(today)
                                                              ? event.getState() == 0
                                                                  ? Colors.lightBlueAccent
                                                                  : event.getState() == 1
                                                                      ? Colors.green
                                                                      : Colors.orange
                                                              : event.getState() == 0
                                                                  ? Colors.redAccent
                                                                  : event.getState() == 1
                                                                      ? Colors.green
                                                                      : Colors.orange),
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(width * 0.06)),
                                                    ),
                                                    child: Text(
                                                      '${event.getType().toString().substring(0, 1)}',
                                                      style: TextStyle(
                                                          color: event.getDateEnd().isAfter(today)
                                                              ? event.getState() == 0
                                                                  ? Colors.lightBlueAccent
                                                                  : event.getState() == 1
                                                                      ? Colors.green
                                                                      : Colors.orange
                                                              : event.getState() == 0
                                                                  ? Colors.redAccent
                                                                  : event.getState() == 1
                                                                      ? Colors.green
                                                                      : Colors.orange,
                                                          fontSize: width * 0.05,
                                                          fontFamily: 'SuezOne'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: width * 0.03,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${event.getType()}',
                                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.004,
                                                  ),
                                                  Text(
                                                    '${event.getTaskSmallTitle()}',
                                                    style: TextStyle(fontSize: 14, color: Colors.blue[700]),
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
                                                  event.getState() == 0
                                                      ? Row(
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
                                                              style: TextStyle(color: Colors.blue[900].withOpacity(0.6), fontSize: 13),
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            Text(
                                                              '- ${event.getDateTimeEnd()}',
                                                              style: TextStyle(color: Colors.blue[900].withOpacity(0.6), fontSize: 13),
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
                                                              style: TextStyle(color: Colors.blue[900].withOpacity(0.6), fontSize: 13),
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            Icon(
                                                              Icons.flag_outlined,
                                                              size: width * 0.04,
                                                              color: Colors.green[800],
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            Text(
                                                              '${event.getCompleteTime()}',
                                                              style: TextStyle(color: Colors.blue[900].withOpacity(0.6), fontSize: 13),
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.05,
                                                            ),
                                                            Icon(
                                                              Icons.timer,
                                                              size: width * 0.04,
                                                              color: Colors.green[800],
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            Text(
                                                              '${event.getDuration()}',
                                                              style: TextStyle(color: Colors.blue[900].withOpacity(0.6), fontSize: 13),
                                                            ),
                                                          ],
                                                        )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                )
                .toList(),
          );
  }

  void _onLogoutButton() {
    Dialogs.bottomMaterialDialog(msg: '${AppLocalizations.getString("logout_dialog_msg")}', title: '${AppLocalizations.getString("logout_dialog_title")}', context: context, actions: [
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
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', -1);
          await prefs.setString('user_mail', "");
          await prefs.setString('user_password', "");
          TakvimSonKalinanYer tSKY = Provider.of<TakvimSonKalinanYer>(context, listen: false);
          tSKY.setValues(tiklananDay, isCalendarVisible, clickedDayDateTitle, selectedDayTasks, calendarOpacity, cardListOpacity);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        text: '${AppLocalizations.getString("dialog_answer_logout")}',
        iconData: Icons.check_circle_outline,
        color: Colors.lightBlueAccent,
        textStyle: TextStyle(color: Colors.white),
        iconColor: Colors.white,
      ),
    ]);
  }

  void exitDialogShow() async {
    if (isCalendarVisible) {
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
    }
  }

  Future<bool> _onBackPressed() async {
    if (!isCalendarVisible) {
      takvimGosterGizle();
      return false;
    } else {
      exitDialogShow();
      return false;
    }
  }

  void reloadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? 0;

    getTasksByUserId(userId);
  }

  getTasksByUserId(int userId) async {
    GetTask getTaskApiModel = GetTask(userId: userId);

    await getTask(getTaskApiModel).then((value) async {
      if (value != null) {
        Provider.of<EventsProvider>(context, listen: false).setEvents(value);
        showToast(context, '${AppLocalizations.getString("success_reload_task")}', gravity: ToastGravity.BOTTOM);
      } else {
        showToast(context, '${AppLocalizations.getString("err_undefined_error")}', gravity: ToastGravity.BOTTOM);
      }
    });

    return null;
  }

  void takvimGosterGizle() {
    if (!isCalendarVisible) {
      setState(() {
        cardListOpacity = 0;
        Future.delayed(Duration(milliseconds: 300)).then((_) {
          setState(() {
            isCalendarVisible = true;
            calendarOpacity = 1;
          });
        });
      });
    } else {
      setState(() {
        calendarOpacity = 0;
        Future.delayed(Duration(milliseconds: 300)).then((_) {
          setState(() {
            isCalendarVisible = false;
            cardListOpacity = 1;
          });
        });
      });
    }
  }

  void _onHeaderTapped(DateTime dateTime) {
    takvimGosterGizle();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    List tmp = events ?? [];
    tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
    tmp.sort((a, b) => a.state.compareTo(b.state));
    setState(() {
      if (events.isNotEmpty) {
        takvimGosterGizle();
        clickedDayDateTitle = DateFormat("d MMMM y", Localizations.localeOf(context).languageCode).format(day);
        tiklananDay = day;
        selectedDayTasks = tmp;
      } else {
        if (tiklananDay == day) {
          takvimGosterGizle();
          clickedDayDateTitle = DateFormat("d MMMM y", Localizations.localeOf(context).languageCode).format(day);
          selectedDayTasks = tmp;
        } else {
          tiklananDay = day;
        }
      }
    });
  }

  void cardListRightLeftClick(bool isRight) {
    if (isRight) {
      setState(() {
        cardListNextOpacity = 0;
      });
      Future.delayed(Duration(milliseconds: 200)).then((_) {
        setState(() {
          cardListNextOpacity = 1;
          clickedDayDateTitle = DateFormat("d MMMM y", Localizations.localeOf(context).languageCode).format(tiklananDay.add(Duration(days: 1)));
          tiklananDay = tiklananDay.add(Duration(days: 1));
          List tmp = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
          tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
          tmp.sort((a, b) => a.state.compareTo(b.state));
          selectedDayTasks = tmp ?? [];
        });
      });
    } else {
      setState(() {
        cardListNextOpacity = 0;
      });
      Future.delayed(Duration(milliseconds: 200)).then((_) {
        setState(() {
          cardListNextOpacity = 1;
          clickedDayDateTitle = DateFormat("d MMMM y", Localizations.localeOf(context).languageCode).format(tiklananDay.subtract(Duration(days: 1)));
          tiklananDay = tiklananDay.subtract(Duration(days: 1));
          List tmp = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
          tmp.sort((a, b) => a.dateTimeStart.compareTo(b.dateTimeStart));
          tmp.sort((a, b) => a.state.compareTo(b.state));
          selectedDayTasks = tmp ?? [];
        });
      });
    }
  }

  void listEventClick(ClickedEvent clickedEventNesne, dynamic event) {
    TakvimSonKalinanYer tSKY = Provider.of<TakvimSonKalinanYer>(context, listen: false);
    tSKY.setValues(tiklananDay, isCalendarVisible, clickedDayDateTitle, selectedDayTasks, calendarOpacity, cardListOpacity);
    clickedEventNesne.setClickedEvent(event.getType(), event.getDateTimeStart(), event.getDateTimeEnd(), event.getState(), event.getTaskId(), event.getTaskAllInfo(), event.getIncompleteReason());
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailPage()));
  }

  filterTypeDialog(BuildContext context) {
    AppLocalizations.of(context);

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: width * 0.8,
          height: height * 0.6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(height * 0.02)),
          ),
          child: Column(children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  '${AppLocalizations.getString("filter")}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Consumer<EventsProvider>(
              builder: (context, epNesne, child) {
                return Expanded(
                  child: ListView(
                    children: epNesne
                        .getAllTask()
                        .map((task) => ListTile(
                              onTap: () {
                                epNesne.eventFilter(task.taskType.typeTitle, task.id);
                                Navigator.of(context).pop();
                                setState(() {
                                  selectedDayTasks = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
                                });
                              },
                              title: Container(
                                height: height * 0.075,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: height * 0.065,
                                      height: height * 0.065,
                                      margin: EdgeInsets.only(left: width * 0.01),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: Colors.lightBlueAccent),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(height * 0.01)),
                                      ),
                                      child: Text(
                                        '${task.taskType.typeTitle.substring(0, 1)}',
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'SuezOne'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Container(
                                      child: Text(
                                        '${task.taskType.typeTitle}',
                                        style: TextStyle(fontSize: 20, fontFamily: 'SuezOne'),
                                      ),
                                    ),
                                    Spacer(),
                                    epNesne.selectedType == task.id.toString()
                                        ? Icon(
                                            Icons.check_circle_sharp,
                                            size: width * 0.06,
                                            color: Colors.black,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8),
              child: MaterialButton(
                color: Colors.lightBlueAccent,
                textColor: Colors.white,
                onPressed: () {
                  Provider.of<EventsProvider>(context, listen: false).eventFilter("all", 0);
                  Navigator.of(context).pop();
                  setState(() {
                    selectedDayTasks = userTasks[DateTime.utc(tiklananDay.year, tiklananDay.month, tiklananDay.day)] ?? [];
                  });
                },
                child: Text(
                  'Sıfırla',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
