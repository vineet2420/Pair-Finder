import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';
import 'package:ipair/Controller/activity_state_provider.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/UserFlow/local_storage.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Common/common_activity_elements.dart';
import 'package:provider/provider.dart';

class ScheduleContent extends StatefulWidget {
  final User user;
  const ScheduleContent(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScheduleContentState();

}

class _ScheduleContentState extends State<ScheduleContent> {
  @override
  Widget build(BuildContext context) => Consumer<ActivityStateProvider>(
        builder: (context, activityStateProvider, child) => setupSchedule());

  Widget setupSchedule() {

    return SingleChildScrollView(
        child:Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CommonActivityElements().activityListHeader("Sent:"),
       CommonActivityElements().displayAllActivities(ActivityHandler().sentActivities, widget.user, false, context),
        CommonActivityElements().activityListHeader("Going:"),
       CommonActivityElements().displayAllActivities(ActivityHandler().attendingActivities, widget.user, false, context),
      ],
    ));
  }
}
