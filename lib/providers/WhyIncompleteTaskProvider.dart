import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/why_incomplete_reason_model.dart';

class WhyIncompleteTaskProvider extends ChangeNotifier{
  List<WhyIncompleteReasonModel> reasons = [WhyIncompleteReasonModel(id: 0, title: "Yok", company: null)];

  List<WhyIncompleteReasonModel> getReasons() => reasons;

  void setReasons(List<WhyIncompleteReasonModel> item){
    reasons = item;
    notifyListeners();
  }
}