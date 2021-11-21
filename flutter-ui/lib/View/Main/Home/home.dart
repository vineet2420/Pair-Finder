import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ipair/ActivityFlow/activity.dart';
import 'package:ipair/ActivityFlow/activity_handler.dart';
import 'package:ipair/Controller/activity_controller.dart';
import 'package:ipair/Controller/tab_state_provider.dart';
import 'package:ipair/Model/activity_model.dart';
import 'package:ipair/UserFlow/user.dart';
import 'package:ipair/View/Common/common_ui_elements.dart';
import 'package:provider/provider.dart';
import '../Activity/activity_content.dart';
import '../Schedule/schedule_content.dart';
import 'home_content.dart';
import 'package:ipair/Controller/activity_state_provider.dart';

// For the home page UI
class HomePage extends StatefulWidget {
  final User user;

  const HomePage(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
 // int indexToSet = 0;
  late List<Widget> widgetPages;
  User user = User();
  List<String> cachedData = <String>["", "", "", ""];
  bool displayedPermissionDenied = false;
  late TabStateProvider tabProvider;

  Future main() async {
    user = widget.user;
    // print(user.getFullName());

    await requestUserLocation();
  }

  @protected
  @mustCallSuper
  void initState() {
    tabProvider = Provider.of<TabStateProvider>(context, listen: false);
    // Display new activities in real time
    ActivityController().displayNewActivity(context, widget.user);
    print("in init");

    FetchSentAndGoingActivities();

    // Call after frame is rendered
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      main();
    });

    // Detected device state changes such as foreground
    WidgetsBinding.instance!.addObserver(this);
  }

  void FetchSentAndGoingActivities() async {
    ActivityStateProvider activityStateProvider = Provider.of<ActivityStateProvider>(context, listen: false);

    List<Activity> sentActivities = await ActivityController().fetchActivities(widget.user, FetchActivityType.Sent, context);
    activityStateProvider.addSentActivities(sentActivities);

    List<Activity> goingActivities = await ActivityController().fetchActivities(widget.user, FetchActivityType.Going, context);
    activityStateProvider.addGoingActivities(goingActivities);

    // print("Sent activities $sentActivities");
  }


  onTabSelected(int requestedIndex) {

    tabProvider.changeTab(requestedIndex);
    setState(() {
      //indexToSet = requestedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    widgetPages = [
      HomeContent(),
      ActivityContent(user),
      ScheduleContent()
    ];

    return Consumer<TabStateProvider>(
        builder: (context, tabProvider, child) => CupertinoPageScaffold(
        child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)
    {
      return navigationController(tabProvider.tab == 0
          ? 'Welcome, ${widget.user.getFirstName()}'
          : tabProvider.tab == 1
          ? "Create Activity"
          : "My Activities");
    },
    body: Scaffold(
    body: widgetPages[tabProvider.tab],
    bottomNavigationBar: bottomNavBar(),
    ),
    ),
    ));
  }

  List<Widget> navigationController(String navBarText) {
    return <Widget>[
      CupertinoSliverNavigationBar(
        automaticallyImplyLeading: false,
        largeTitle: AutoSizeText(navBarText),
        trailing: tabProvider.tab == 0 ? accountSettings() : null,
      )
    ];
  }

  Widget accountSettings() {
    return Material(
        child: IconButton(
          icon: const Icon(Icons.manage_accounts_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/account', arguments: user);
          },
        ));
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: tabProvider.tab,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Create'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Activities'),
      ],
    );
  }

  Future<void> requestUserLocation() async {
    ActivityStateProvider activityStateProvider = Provider.of<ActivityStateProvider>(context, listen: false);

    try {
      Position pos = await ActivityController().getUserLocation(context);
      user.latitude = pos.latitude;
      user.longitude = pos.longitude;

      // print(user.latitude);

      if (displayedPermissionDenied) {
        Navigator.of(context).pop();
        displayedPermissionDenied = false;
      }

      activityStateProvider.addAllNearByActivities(await ActivityController().fetchActivities(user, FetchActivityType.Near, context));
    }
    catch (e) {
      if (!displayedPermissionDenied) {
        ActivityController().permissionDeniedMessage(context);
        displayedPermissionDenied = true;
        print(e);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (user.latitude == 0) {
          requestUserLocation();
        }
        print("Back");
        break;
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.detached:
        print("Detached");
        ActivityController().disconnectSocket();
        break;
      default:
        print("Here");
        break;
    }
  }

}
