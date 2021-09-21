import 'package:flutter/material.dart';
import 'package:flutter_app/models/events_model.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsProvider extends ChangeNotifier {
  Map<DateTime, List> _events = {
    DateTime.utc(2001, 02, 10): [
      EventModel(DateTime.utc(2021, 02, 10, 12, 30), DateTime.utc(2021, 02, 10, 13, 30), "Temizlik", 0, 1, null),
    ],
  };

  Map<DateTime, List> _qrTasks = {};
  List<GetTaskResult> value;
  String selectedType = "all";

  Map<DateTime, List> getEvents() => _events;

  Map<DateTime, List> getQrEvents() => _qrTasks;

  List<GetTaskResult> getAllTask() => value;

  void eventFilter(String filterValue, int taskId) {
    _events.clear();
    selectedType = taskId.toString();
    List<GetTaskResult> tmp = [];
    for (GetTaskResult task in value) {
      if (filterValue == "all") {
        tmp.add(task);
      } else {
        if (task.id == taskId) {
          tmp.add(task);
        }
      }
    }

    DateTime eventDay, startingTime, finishTime;
    String taskType;
    int taskState;

    for (GetTaskResult task in tmp) {
      for (TaskTime taskTime in task.taskTimes) {
        eventDay = DateTime.utc(taskTime.startDate.year, taskTime.startDate.month, taskTime.startDate.day);
        startingTime = taskTime.startDate;
        finishTime = taskTime.finishDate;
        taskType = task.taskType.typeTitle;
        taskState = taskTime.state;

        if(startingTime.day != finishTime.day && taskTime.duration == 0){
          taskTime.duration = 1;
        }

        if (_events[eventDay] == null) {
          _events[eventDay] = [EventModel(startingTime, finishTime, taskType, taskState, taskTime.id, task)];
        } else {
          _events[eventDay].add(EventModel(startingTime, finishTime, taskType, taskState, taskTime.id, task));
        }
      }
    }
    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });

  }

  void setEvents(List<GetTaskResult> value) {
    this.value = value;
    _events.clear();
    DateTime eventDay, startingTime, finishTime;
    String taskType;
    int taskState;

    for (GetTaskResult task in value) {
      for (TaskTime taskTime in task.taskTimes) {
        eventDay = DateTime.utc(taskTime.startDate.year, taskTime.startDate.month, taskTime.startDate.day);
        startingTime = taskTime.startDate;
        finishTime = taskTime.finishDate;
        taskType = task.taskType.typeTitle;
        taskState = taskTime.state;

        if(startingTime.day != finishTime.day && taskTime.duration == 0){
          taskTime.duration = 1;
        }

        if (_events[eventDay] == null) {
          _events[eventDay] = [EventModel(startingTime, finishTime, taskType, taskState, taskTime.id, task)];
        } else {
          _events[eventDay].add(EventModel(startingTime, finishTime, taskType, taskState, taskTime.id, task));
        }
      }
    }
    notifyListeners();
  }

  Future setEventsByGuid(List<GetTaskResult> value) async {
    _qrTasks.clear();
    DateTime eventDay, startingTime, finishTime;
    String taskType;
    int taskState;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id') ?? '';
    for (GetTaskResult task in value) {
      for (TaskTime taskTime in task.taskTimes) {
        if (taskTime.state == 0 && task.user.id == userId) {
          eventDay = DateTime.utc(taskTime.startDate.year, taskTime.startDate.month, taskTime.startDate.day);
          startingTime = taskTime.startDate;
          finishTime = taskTime.finishDate;
          taskType = task.taskType.typeTitle;
          taskState = taskTime.state;

          if(startingTime.day != finishTime.day && taskTime.duration == 0){
            taskTime.duration = 1;
          }

          if (_qrTasks[eventDay] == null) {
            _qrTasks[eventDay] = [EventModel(startingTime, finishTime, taskType, taskState, taskTime.id, task)];
          } else {
            _qrTasks[eventDay].add(EventModel(startingTime, finishTime, taskType, taskState, taskTime.id, task));
          }
        }
      }
    }
    notifyListeners();
  }
}
