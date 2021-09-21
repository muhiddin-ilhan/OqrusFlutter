import 'package:flutter/material.dart';

class TakvimSonKalinanYer extends ChangeNotifier{
  DateTime tiklananDay = DateTime.now();
  bool isCalendarVisible = true;
  String tiklananDayTarihBaslik = "";
  List selectedEvents;
  double calendarOpacity = 1;
  double cardListOpacity = 0;

  void setValues(DateTime tiklananDay, bool isCalendarVisible, String tiklananDayTarihBaslik, List selectedEvents, double calendarOpacity, double cardListOpacity){
    this.tiklananDay = tiklananDay;
    this.isCalendarVisible = isCalendarVisible;
    this.tiklananDayTarihBaslik = tiklananDayTarihBaslik;
    this.selectedEvents = selectedEvents;
    this.calendarOpacity = calendarOpacity;
    this.cardListOpacity = cardListOpacity;
    notifyListeners();
  }

  bool getIsCalendarVisible() => isCalendarVisible;
  DateTime getTiklananDay() => tiklananDay;
  String getTiklananDayTarihBaslik() => tiklananDayTarihBaslik;
  List getSelectedEvents() => selectedEvents;
  double getCalendarOpacity() => calendarOpacity;
  double getCardListOpacity() => cardListOpacity;
}