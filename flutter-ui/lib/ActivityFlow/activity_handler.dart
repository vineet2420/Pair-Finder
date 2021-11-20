import 'activity.dart';

class ActivityHandler{


  static final ActivityHandler _singleton = ActivityHandler._internal();

  factory ActivityHandler() {
    return _singleton;
  }

  ActivityHandler._internal();

  List<Activity> nearByActivities = [];
  List<Activity> sentActivities = [];
  List<Activity> attendingActivities = [];

}