import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/localization/app_localization.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:flutter_app/models/task_report_model.dart';
import 'package:flutter_app/providers/events_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String filterDate = "Today";
  List<GetTaskResult> allTasks;
  int okTaskCount = 0, notTaskCount = 0, cantTaskCount = 0;
  DateTime today = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 1);
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    allTasks = Provider.of<EventsProvider>(context, listen: false).getAllTask();
    for (GetTaskResult task in allTasks) {
      for (TaskTime time in task.taskTimes) {
        if (time.startDate.day == today.day) {
          if (time.state == 0) {
            notTaskCount++;
          } else if (time.state == 1) {
            okTaskCount++;
          } else {
            cantTaskCount++;
          }
        }
      }
    }
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
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: topSafeSize),
          height: height,
          color: Colors.lightBlueAccent,
          child: Column(
            children: [
              pageTitleWidget(height, width),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(width * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height * 0.04),
                      topLeft: Radius.circular(height * 0.04),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        selectDate(height, width),
                        SizedBox(height: height * 0.02),
                        taskCompleteCountCard(height, width),
                        SizedBox(height: height * 0.02),
                        Consumer<EventsProvider>(builder: (context, epNesne, child) {
                          return taskTitleProgressBarReportCard(height, width, epNesne);
                        }),
                        SizedBox(height: height * 0.02),
                        Consumer<EventsProvider>(builder: (context, epNesne, child) {
                          return adressProgressBarReportCard(height, width, epNesne);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget adressProgressBarReportCard(double height, double width, EventsProvider eventsProvider) {
    List<GetTaskResult> allTasks = eventsProvider.getAllTask();
    List<String> address = [];
    List<TaskReportModel> taskReportModel = [];
    int i = 1;

    for (GetTaskResult task in allTasks) {
      if (!address.contains(task.places[0].placeTitle)) {
        address.add(task.places[0].placeTitle);
      }
    }

    for (String adres in address) {
      TaskReportModel tmpTaskReportModel = new TaskReportModel(
          title: adres,
          fullSize: 0,
          completedSize: 0,
          color: i % 4 == 0
              ? Colors.lightBlueAccent
              : i % 4 == 1
                  ? Colors.red
                  : i % 4 == 2
                      ? Colors.green
                      : i % 4 == 3
                          ? Colors.amberAccent
                          : Colors.teal);
      i = i + 1;
      for (GetTaskResult task in allTasks) {
        if (task.places[0].placeTitle == adres) {
          for (TaskTime taskTime in task.taskTimes) {
            if (filterDate == "Today") {
              if (taskTime.startDate.day == today.day) {
                tmpTaskReportModel.fullSize = tmpTaskReportModel.fullSize + 1;
                if (taskTime.state == 1) {
                  tmpTaskReportModel.completedSize = tmpTaskReportModel.completedSize + 1;
                }
              }
            } else if (filterDate == "Week") {
              DateTime haftaBasi = today.subtract(Duration(days: today.weekday - 1));
              DateTime haftaSonu = today.add(Duration(days: today.weekday));
              if (taskTime.startDate.isAfter(haftaBasi) && taskTime.startDate.isBefore(haftaSonu)) {
                tmpTaskReportModel.fullSize = tmpTaskReportModel.fullSize + 1;
                if (taskTime.state == 1) {
                  tmpTaskReportModel.completedSize = tmpTaskReportModel.completedSize + 1;
                }
              }
            } else {
              DateTime ayBasi = DateTime.utc(DateTime.now().year, DateTime.now().month, 1, 0, 1);
              DateTime aySonu = DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1, 0, 1);
              if (taskTime.startDate.isAfter(ayBasi) && taskTime.startDate.isBefore(aySonu)) {
                tmpTaskReportModel.fullSize = tmpTaskReportModel.fullSize + 1;
                if (taskTime.state == 1) {
                  tmpTaskReportModel.completedSize = tmpTaskReportModel.completedSize + 1;
                }
              }
            }
          }
        }
      }
      if (tmpTaskReportModel.fullSize != 0) {
        taskReportModel.add(tmpTaskReportModel);
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 18, bottom: 18, right: 25, left: 25),
      height: height * 0.35,
      decoration: BoxDecoration(
        color: Color.fromRGBO(252, 252, 255, 1),
        border: Border.all(color: Colors.lightBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(height * 0.012)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(211, 211, 211, 1),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            child: Text("Adrese Göre", style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Farro")),
          ),
          Container(
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(top: height * 0.015, bottom: height * 0.015),
          ),
          Expanded(
            child: taskReportModel.length != 0
                ? ListView(
                    padding: EdgeInsets.all(0),
                    children: taskReportModel
                        .map((item) => ListTile(
                              title: progressBarWidgetForTitle(height, width, item),
                            ))
                        .toList())
                : Center(
                    child: Text("Görev Bulunamadı"),
                  ),
          )
        ],
      ),
    );
  }

  Widget taskTitleProgressBarReportCard(double height, double width, EventsProvider eventsProvider) {
    List<GetTaskResult> allTasks = eventsProvider.getAllTask();
    List<String> taskTitles = [];
    List<TaskReportModel> taskReportModel = [];
    int i = 1;

    for (GetTaskResult task in allTasks) {
      if (!taskTitles.contains(task.taskTitle)) {
        taskTitles.add(task.taskTitle);
      }
    }

    for (String taskTitle in taskTitles) {
      TaskReportModel tmpTaskReportModel = new TaskReportModel(
          title: taskTitle,
          fullSize: 0,
          completedSize: 0,
          color: i % 4 == 4
              ? Colors.lightBlueAccent
              : i % 4 == 3
                  ? Colors.red
                  : i % 4 == 2
                      ? Colors.green
                      : i % 4 == 1
                          ? Colors.amberAccent
                          : Colors.teal);
      i = i + 1;
      for (GetTaskResult task in allTasks) {
        if (task.taskTitle == taskTitle) {
          for (TaskTime taskTime in task.taskTimes) {
            if (filterDate == "Today") {
              if (taskTime.startDate.day == today.day) {
                tmpTaskReportModel.fullSize = tmpTaskReportModel.fullSize + 1;
                if (taskTime.state == 1) {
                  tmpTaskReportModel.completedSize = tmpTaskReportModel.completedSize + 1;
                }
              }
            } else if (filterDate == "Week") {
              DateTime haftaBasi = today.subtract(Duration(days: today.weekday - 1));
              DateTime haftaSonu = today.add(Duration(days: today.weekday));
              if (taskTime.startDate.isAfter(haftaBasi) && taskTime.startDate.isBefore(haftaSonu)) {
                tmpTaskReportModel.fullSize = tmpTaskReportModel.fullSize + 1;
                if (taskTime.state == 1) {
                  tmpTaskReportModel.completedSize = tmpTaskReportModel.completedSize + 1;
                }
              }
            } else {
              DateTime ayBasi = DateTime.utc(DateTime.now().year, DateTime.now().month, 1, 0, 1);
              DateTime aySonu = DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1, 0, 1);
              if (taskTime.startDate.isAfter(ayBasi) && taskTime.startDate.isBefore(aySonu)) {
                tmpTaskReportModel.fullSize = tmpTaskReportModel.fullSize + 1;
                if (taskTime.state == 1) {
                  tmpTaskReportModel.completedSize = tmpTaskReportModel.completedSize + 1;
                }
              }
            }
          }
        }
      }
      if (tmpTaskReportModel.fullSize != 0) {
        taskReportModel.add(tmpTaskReportModel);
      }
    }

    return Container(
      padding: EdgeInsets.only(top: 18, bottom: 18, right: 25, left: 25),
      height: height * 0.35,
      decoration: BoxDecoration(
        color: Color.fromRGBO(252, 252, 255, 1),
        border: Border.all(color: Colors.lightBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(height * 0.012)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(211, 211, 211, 1),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            child: Text("Görev Başlıkları", style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Farro")),
          ),
          Container(
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(top: height * 0.015, bottom: height * 0.015),
          ),
          Expanded(
            child: taskReportModel.length != 0
                ? ListView(
                    padding: EdgeInsets.all(0),
                    children: taskReportModel
                        .map((item) => ListTile(
                              title: progressBarWidgetForTitle(height, width, item),
                            ))
                        .toList())
                : Center(
                    child: Text("Görev Bulunamadı"),
                  ),
          )
        ],
      ),
    );
  }

  Widget progressBarWidgetForTitle(double height, double width, TaskReportModel taskReportModel) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3, right: 3),
                child: Text(
                  taskReportModel.title,
                  style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3, right: 3),
                child: Text(
                  "${taskReportModel.completedSize}/${taskReportModel.fullSize}",
                  style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.normal),
                ),
              )
            ],
          ),
          SizedBox(
            height: height * 0.0055,
          ),
          LinearPercentIndicator(
            lineHeight: height * 0.02,
            percent: taskReportModel.getPercent(),
            backgroundColor: Color.fromRGBO(233, 233, 233, 1),
            progressColor: taskReportModel.color,
          )
        ],
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
              '${AppLocalizations.getString("page_title_report_page")}',
              style: TextStyle(fontSize: width * 0.07, fontFamily: 'SuezOne', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectDate(double height, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            if(!isButtonDisabled){
              onClickFilterDate("Today");
            }
          },
          child: Container(
            child: Center(
              child: Text(
                "Bugün",
                style: TextStyle(fontSize: 17, color: Colors.blue[900], fontWeight: FontWeight.bold),
              ),
            ),
            padding: EdgeInsets.all(12),
            width: width * 0.28,
            decoration: BoxDecoration(
              color: filterDate == "Today" ? Colors.lightBlueAccent : Color.fromRGBO(252, 252, 255, 1),
              border: Border.all(color: Colors.lightBlueAccent),
              borderRadius: BorderRadius.all(Radius.circular(height * 0.012)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(211, 211, 211, 1),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if(!isButtonDisabled){
              onClickFilterDate("Week");
            }
          },
          child: Container(
            child: Center(
              child: Text(
                "Haftalık",
                style: TextStyle(fontSize: 17, color: Colors.blue[900], fontWeight: FontWeight.bold),
              ),
            ),
            padding: EdgeInsets.all(12),
            width: width * 0.28,
            decoration: BoxDecoration(
              color: filterDate == "Week" ? Colors.lightBlueAccent : Color.fromRGBO(252, 252, 255, 1),
              border: Border.all(color: Colors.lightBlueAccent),
              borderRadius: BorderRadius.all(
                Radius.circular(height * 0.012),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(211, 211, 211, 1),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if(!isButtonDisabled){
              onClickFilterDate("Month");
            }
          },
          child: Container(
            child: Center(
              child: Text(
                "Aylık",
                style: TextStyle(fontSize: 17, color: Colors.blue[900], fontWeight: FontWeight.bold),
              ),
            ),
            padding: EdgeInsets.all(12),
            width: width * 0.28,
            decoration: BoxDecoration(
              color: filterDate == "Month" ? Colors.lightBlueAccent : Color.fromRGBO(252, 252, 255, 1),
              border: Border.all(color: Colors.lightBlueAccent),
              borderRadius: BorderRadius.all(Radius.circular(height * 0.012)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(211, 211, 211, 1),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(1.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget taskCompleteCountCard(double height, double width) {
    double countFontSize = 25;
    double countCircleSize = width * 0.175;
    double sizedBoxHeight = height * 0.02;
    double botTextFontSize = 20;
    Color countFontColor = Colors.green[700];
    Color botTextColor = Colors.green[700];
    FontWeight botTextFontWeight = FontWeight.bold;
    FontWeight countFontWeight = FontWeight.bold;

    return Container(
      padding: EdgeInsets.only(top: 18, bottom: 18, right: 25, left: 25),
      decoration: BoxDecoration(
        color: Color.fromRGBO(252, 252, 255, 1),
        border: Border.all(color: Colors.lightBlueAccent),
        borderRadius: BorderRadius.all(Radius.circular(height * 0.012)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(211, 211, 211, 1),
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                    okTaskCount.toString(),
                    style: TextStyle(fontSize: countFontSize, color: countFontColor, fontWeight: countFontWeight),
                  ),
                ),
                padding: EdgeInsets.all(12),
                height: countCircleSize,
                width: countCircleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green[600]),
                  borderRadius: BorderRadius.all(Radius.circular(countCircleSize / 2)),
                ),
              ),
              SizedBox(height: sizedBoxHeight),
              Text(
                "Yapılan",
                style: TextStyle(fontSize: botTextFontSize, color: botTextColor, fontWeight: botTextFontWeight),
              )
            ],
          ),
          Container(
            color: Colors.lightBlueAccent,
            height: height * 0.15,
            width: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                    notTaskCount.toString(),
                    style: TextStyle(fontSize: countFontSize, color: Colors.red[800], fontWeight: countFontWeight),
                  ),
                ),
                padding: EdgeInsets.all(12),
                height: countCircleSize,
                width: countCircleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red[600]),
                  borderRadius: BorderRadius.all(Radius.circular(countCircleSize / 2)),
                ),
              ),
              SizedBox(height: sizedBoxHeight),
              Text(
                "Eksik",
                style: TextStyle(fontSize: botTextFontSize, color: Colors.red[600], fontWeight: botTextFontWeight),
              )
            ],
          ),
          Container(
            color: Colors.lightBlueAccent,
            height: height * 0.15,
            width: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                    cantTaskCount.toString(),
                    style: TextStyle(fontSize: countFontSize, color: Colors.orange[700], fontWeight: countFontWeight),
                  ),
                ),
                padding: EdgeInsets.all(12),
                height: countCircleSize,
                width: countCircleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange[600]),
                  borderRadius: BorderRadius.all(Radius.circular(countCircleSize / 2)),
                ),
              ),
              SizedBox(height: sizedBoxHeight),
              Text(
                "İptal",
                style: TextStyle(fontSize: botTextFontSize, color: Colors.orange[700], fontWeight: botTextFontWeight),
              )
            ],
          )
        ],
      ),
    );
  }

  void onClickFilterDate(String filterString) async {
    int tmpOkTaskCount = 0, tmpNotTaskCount = 0, tmpCantTaskCount = 0;

    if (filterString == "Today") {
      for (GetTaskResult task in allTasks) {
        for (TaskTime time in task.taskTimes) {
          if (time.startDate.day == today.day) {
            if (time.state == 0) {
              tmpNotTaskCount++;
            } else if (time.state == 1) {
              tmpOkTaskCount++;
            } else {
              tmpCantTaskCount++;
            }
          }
        }
      }
    } else if (filterString == "Week") {
      DateTime haftaBasi = today.subtract(Duration(days: today.weekday - 1));
      DateTime haftaSonu = today.add(Duration(days: today.weekday));
      for (GetTaskResult task in allTasks) {
        for (TaskTime time in task.taskTimes) {
          if (time.startDate.isAfter(haftaBasi) && time.startDate.isBefore(haftaSonu)) {
            if (time.state == 0) {
              tmpNotTaskCount++;
            } else if (time.state == 1) {
              tmpOkTaskCount++;
            } else {
              tmpCantTaskCount++;
            }
          }
        }
      }
    } else if (filterString == "Month") {
      DateTime ayBasi = DateTime.utc(DateTime.now().year, DateTime.now().month, 1, 0, 1);
      DateTime aySonu = DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 1, 0, 1);
      for (GetTaskResult task in allTasks) {
        for (TaskTime time in task.taskTimes) {
          if (time.startDate.isAfter(ayBasi) && time.startDate.isBefore(aySonu)) {
            if (time.state == 0) {
              tmpNotTaskCount++;
            } else if (time.state == 1) {
              tmpOkTaskCount++;
            } else {
              tmpCantTaskCount++;
            }
          }
        }
      }
    }

    setState(() {
      filterDate = filterString;
      isButtonDisabled = true;
    });

    while ((okTaskCount != tmpOkTaskCount || notTaskCount != tmpNotTaskCount || cantTaskCount != tmpCantTaskCount)) {
      await Future.delayed(Duration(milliseconds: 50), () {
          setState(() {
            okTaskCount = okTaskCount != tmpOkTaskCount ? okTaskCount < tmpOkTaskCount ? okTaskCount + 1 : okTaskCount - 1 : tmpOkTaskCount;
            notTaskCount = notTaskCount != tmpNotTaskCount ? notTaskCount < tmpNotTaskCount ? notTaskCount + 1 : notTaskCount - 1 : tmpNotTaskCount;
            cantTaskCount = cantTaskCount != tmpCantTaskCount ? cantTaskCount < tmpCantTaskCount ? cantTaskCount + 1 : cantTaskCount - 1 : tmpCantTaskCount;
          });
      });
    }

    setState(() {
      isButtonDisabled = false;
    });
  }

  Future<bool> _onBackPressed() async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    return false;
  }
}
