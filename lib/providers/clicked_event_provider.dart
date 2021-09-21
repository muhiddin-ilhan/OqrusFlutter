import 'package:flutter/material.dart';
import 'package:flutter_app/models/get_task_result.dart';
import 'package:intl/intl.dart';

class ClickedEvent extends ChangeNotifier{
  String title, startTime, endTime, address;
  int state, timesId;
  IncompleteReason incompleteReason;
  GetTaskResult allTaskInfo;

  String getTitle() => title;
  String getStartTime() => startTime;
  String getEndTime() => endTime;
  int getState() => state;
  int getId() => timesId;
  GetTaskResult getAllTaskInfo() => allTaskInfo;
  String getIncompleteReason() => incompleteReason.title;

  String getAddress(){
    String tmp = "";
    for (Place place in allTaskInfo.places){
      if(place.parentPlaceId != 0){
        tmp += place.placeTitle + ", ";
      }else{
        tmp += place.placeTitle;
      }
    }
    return tmp;
  }

  TaskTime getTaskTime(int id){
    for(TaskTime t in allTaskInfo.taskTimes){
      if(t.id == id){
        return t;
      }
    }
    return null;
  }

  String getDuration() {
    if (getTaskTime(timesId).duration == 0){
      DateTime tmpStartTime = DateFormat("HH:mm").parse(startTime);
      DateTime tmpEndTime = DateFormat("HH:mm").parse(endTime);
      return tmpEndTime.difference(tmpStartTime).inMinutes.toString()+ " Dakika";
    }else if (getTaskTime(timesId).duration == 7){
      return 'Haftalık Görev';
    }else if (getTaskTime(timesId).duration == 31){
      return 'Aylık Görev';
    }else if (getTaskTime(timesId).duration == 1){
      return 'Tek Seferlik';
    }
    return 'Null';
  }

  String isFuture(){
    if(getTaskTime(timesId).startDate.isAfter(new DateTime.now())){
      if(getTaskTime(timesId).state == 0){
        return "Gelecekteki Görev";
      }else if(getTaskTime(timesId).state == 1){
        return "Gelecek Yapılmış Görev";
      }else{
        return "Gelecek Yapılamamış Görev";
      }
    }else{
      if(getTaskTime(timesId).state == 0){
        return "Yapılmamış Görev";
      }else if(getTaskTime(timesId).state == 1){
        return "Yapılmış Görev";
      }else{
        return "Yapılamamış Görev";
      }
    }
  }

  void setClickedEvent (String title, String startTime, String endTime, int state, int timesId, GetTaskResult allTaskInfo, IncompleteReason incompleteReason){
    this.title = title;
    this.startTime = startTime;
    this.endTime = endTime;
    this.allTaskInfo = allTaskInfo;
    this.state = state;
    this.timesId = timesId;
    this.incompleteReason = incompleteReason;
    notifyListeners();
  }
}