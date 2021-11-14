import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:ipair/Controller/activity_controller.dart';
import 'package:ipair/UserFlow/user.dart';
import '../Activity/activity_content.dart';
import '../Schedule/schedule_content.dart';
import 'home_content.dart';

// For the home page UI
class HomePage extends StatefulWidget {
  final User user;

  const HomePage(User this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int indexToSet = 0;
  late List<Widget> widgetPages;
  User user = User();
  List<String> cachedData = <String>["", "", "", ""];

  Future main() async {
    user = widget.user;
    print(user.getFullName());
  }

  @protected
  @mustCallSuper
  void initState() {
    // Display new activities in real time
    ActivityController().displayNewActivity(context);

    // Call after frame is rendered
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      main();
    });

    // Detected device state changes such as foreground
    WidgetsBinding.instance!.addObserver(this);
  }

  onTabSelected(int requestedIndex) {
    setState(() {
      indexToSet = requestedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    widgetPages = [
      HomeContent(),
      ActivityContent(),
      ScheduleContent().setupSchedule()
    ];

    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return navigationController(indexToSet == 0
              ? 'Welcome, ${widget.user.getFirstName()}'
              : indexToSet == 1
                  ? "Create Activity"
                  : "My Activities");
        },
        body: Scaffold(
          body: widgetPages[indexToSet],
          bottomNavigationBar: bottomNavBar(),
        ),
      ),
    );
  }

  List<Widget> navigationController(String navBarText) {
    return <Widget>[
      CupertinoSliverNavigationBar(
        largeTitle: AutoSizeText(navBarText),
        trailing: indexToSet == 0 ? accountSettings() : null,
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
      currentIndex: indexToSet,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.create), label: 'Create'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Activities'),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
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
