import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';
import 'package:ipair/Controller/activity_state_provider.dart';
import 'package:ipair/View/Common/common_activity_elements.dart';
import 'package:provider/provider.dart';

class ScheduleContent extends StatefulWidget {
  const ScheduleContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScheduleContentState();

}

class _ScheduleContentState extends State<ScheduleContent> {
  @override
  Widget build(BuildContext context) => Consumer<ActivityStateProvider>(
        builder: (context, activityStateProvider, child) => setupSchedule());

  Widget setupSchedule() {

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CommonActivityElements().activityListHeader("Sent:"),
        CommonActivityElements().displayAllActivities(ActivityHandler().sentActivities, false, context),
        CommonActivityElements().activityListHeader("Going:"),
        CommonActivityElements().displayAllActivities(ActivityHandler().attendingActivities, false, context),
      ],
    );
  }
}
