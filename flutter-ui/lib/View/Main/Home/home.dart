import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

class _HomePageState extends State<HomePage> {
  int indexToSet = 0;
  late List<Widget> widgetPages;
  User user = User();
  List<String> cachedData = <String>["", "", "", ""];
  String welcomeTitle = '';

  Future main() async {
    user = widget.user;
    print(user.getFullName());
  }

  @protected
  @mustCallSuper
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      main();
    });
  }

  onTabSelected(int requestedIndex) {
    setState(() {
      indexToSet = requestedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {

    widgetPages = [
      HomeContent().setupHomeContent(),
      ActivityContent().setupActivity(),
      ScheduleContent().setupSchedule()
    ];

    return CupertinoPageScaffold(

      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return navigationController('Welcome, ${widget.user.getFirstName()}');
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
        trailing: accountSettings(),
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
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Activities'),
      ],
    );
  }
}
