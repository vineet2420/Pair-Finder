import 'package:flutter/material.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';

class ActivityStateProvider extends ChangeNotifier {

  String activityName = "";

  void addAllNearByActivities(List<Activity> activities) {
    ActivityHandler().nearByActivities = activities;
    notifyListeners();
  }

  void addNearByActivity(Activity activity) {
    ActivityHandler().nearByActivities.add(activity);
    notifyListeners();
  }

  void addSentActivities(List<Activity> activities){
    ActivityHandler().sentActivities = activities;
    notifyListeners();
  }

  void addGoingActivities(List<Activity> activities){
    ActivityHandler().attendingActivities = activities;
    notifyListeners();
  }

  void setActivityName(String name){
    activityName = name;
    notifyListeners();
  }
}