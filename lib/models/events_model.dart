
import 'package:flutter_app/models/get_task_result.dart';
import 'package:intl/intl.dart';

class EventModel {
  DateTime dateTimeStart;
  DateTime dateTimeEnd;
  String type;
  int state, timesId;
  GetTaskResult taskAllInfo;
  TaskTime taskTime;

  EventModel(this.dateTimeStart, this.dateTimeEnd, this.type, this.state , this.timesId,this.taskAllInfo);

  TaskTime getTaskTime(int id){
    for(TaskTime t in taskAllInfo.taskTimes){
      if(t.id == id){
        return t;
      }
    }
    return null;
  }

  int getState(){
    return state;
  }

  int getTaskId(){
    return timesId;
  }

  DateTime getDateStart(){
    return dateTimeStart;
  }

  DateTime getDateEnd(){
    return dateTimeEnd;
  }

  String getDateTimeStart (){
    if (dateTimeStart.difference(dateTimeEnd).inDays == 0){
      String _startTime = DateFormat("HH:mm").format(dateTimeStart);
      return _startTime;
    }else if (dateTimeStart.difference(dateTimeEnd).inDays > 0){
      String _startTime = DateFormat("d MMMM", 'tr_TR').format(dateTimeStart);
      return _startTime;
    }
    return 'Null';
  }

  String getDateTimeEnd (){
    if (dateTimeStart.difference(dateTimeEnd).inDays == 0){
      String _endTime = DateFormat("HH:mm").format(dateTimeEnd);
      return _endTime;
    }else if (dateTimeStart.difference(dateTimeEnd).inDays > 0){
      String _endTime = DateFormat("d MMMM", 'tr_TR').format(dateTimeEnd);
      return _endTime;
    }
    return 'Null';
  }

  String getCompleteTime(){
    TaskTime tmp = getTaskTime(timesId);
    String _completeTime = DateFormat("d MMMM HH:mm", 'tr_TR').format(tmp.completionTime);
    return _completeTime;
  }

  IncompleteReason getIncompleteReason(){
    TaskTime tmp = getTaskTime(timesId);
    return tmp.incompleteReason ?? null;
  }

  String getType (){
    return type;
  }

  String getTaskSmallTitle(){
    if(taskAllInfo.taskTitle.length > 25){
      return taskAllInfo.taskTitle.substring(0, 25);
    }else{
      return taskAllInfo.taskTitle;
    }
  }

  GetTaskResult getTaskAllInfo(){
    return taskAllInfo;
  }

  String getDuration(){
    if (getTaskTime(timesId).state == 1){
      return "Başarılı";
    }else if(getTaskTime(timesId).state == 2){
      return "Yapılamadı";
    }

    if (getTaskTime(timesId).duration == 0){
      return dateTimeEnd.difference(dateTimeStart).inMinutes.toString()+ " Dakika";
    }else if (getTaskTime(timesId).duration == 7){
      return 'Haftalık';
    }else if (getTaskTime(timesId).duration == 31){
      return 'Aylık';
    }else if (getTaskTime(timesId).duration == 1){
      return 'Tek Seferlik';
    }
    return 'Null';
  }

}