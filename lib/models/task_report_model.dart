import 'dart:ui';

class TaskReportModel {
  String title;
  int fullSize;
  int completedSize;
  Color color;
  double percent;

  TaskReportModel({this.title, this.fullSize, this.completedSize, this.color});

  void setFullSize(int num){
    this.fullSize = num;
  }

  void setCompletedSize(int num){
    this.completedSize = num;
  }

  double getPercent(){
    return (completedSize/fullSize);
  }
}