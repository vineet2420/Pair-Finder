import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';
import 'package:ipair/Controller/activity_state_provider.dart';
import 'package:ipair/Controller/constants.dart';
import 'package:ipair/Controller/tab_state_provider.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Common/common_activity_elements.dart';
import 'package:ipair/View/Main/Schedule/schedule_content.dart';
import 'package:ipair/View/Common/common_ui_elements.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:provider/provider.dart';

class HomeContent extends StatefulWidget {

  final User user;
  const HomeContent(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  List<TextButton> presetButtons = [];

  @override
  Widget build(BuildContext context) => Consumer<ActivityStateProvider>(
      builder: (context, activityStateProvider, child) => setupHomeContent(activityStateProvider));

  Widget setupHomeContent(ActivityStateProvider activityStateProvider) {

    TabStateProvider tabProvider = Provider.of<TabStateProvider>(context, listen: false);

    for (int i = 0; i<Constants().icons.length; i++){
      presetButtons.add(TextButton( onPressed: () {
        activityStateProvider.setActivityName(Constants().icons[i].title);
        tabProvider.changeTab(1);
      },
          child: Text(Constants().icons[i].emoji, style: TextStyle(fontSize: 30),)));
    }


    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
            //color: Colors.red,
            height: 150,
            width: double.infinity,
            child: GridView.count(
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                children: presetButtons)),
        SizedBox(height: 20),
        sectionRow("🍴", "Dining"),
        sectionRow("🗺", "Explore"),
        sectionRow("❓", "Random"),
        SizedBox(height: 30),
        // CommonUiElements().sectionHeader('Nearby Activities: '),
        CommonActivityElements().activityListHeader('Nearby Activities: '),
     CommonActivityElements().displayAllActivities(ActivityHandler().nearByActivities, widget.user, true, context)
      ],
    ));
  }

  Widget sectionRow(String emoji, String title) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 100,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(emoji, style: TextStyle(fontSize: 50)),
              Text(title, style: TextStyle(fontSize: 20)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.indigo,
                  ))
            ],
          ),
        ),
        color: Colors.blueGrey.withOpacity(.4),
      ),
      // color: Constants().themeColor.withOpacity(.5),
    );
  }
}
