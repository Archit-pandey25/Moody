import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Files
import './profile_page/profile_page.dart';
import '../utils/brightness.dart';
import '../utils/date.dart';
import '../utils/enums.dart';
import '../widgets/background_images.dart';
import '../widgets/month.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BottomTabOption selectedTab;

  @override
  void initState() {
    selectedTab = BottomTabOption.home;
    super.initState();
  }

  void changeTab(int index) {
    setState(() {
      selectedTab = BottomTabOption.values[index];
    });
  }

  Widget tabBuilder(BuildContext context, int index) {
    if (BottomTabOption.values[index] == BottomTabOption.home) {
      return HomePage();
    } else {
      return ProfilePage();
    }
  }

  final List<BottomNavigationBarItem> bottomTabItems = const [
    BottomNavigationBarItem(
      icon: Icon(c.CupertinoIcons.house_fill),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(c.CupertinoIcons.person_crop_circle_fill),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return m.Scaffold(
      floatingActionButton: m.FloatingActionButton(
        onPressed: () {},
        child: const Icon(m.Icons.edit),
      ),
      bottomNavigationBar: c.CupertinoTabScaffold(
        backgroundColor: const Color(0xFF80C0DB),
        tabBar: c.CupertinoTabBar(
          backgroundColor: const Color(0x00000000),
          border: null,
          onTap: changeTab,
          currentIndex: selectedTab.index,
          items: bottomTabItems,
        ),
        tabBuilder: tabBuilder,
      ),
    );
  }
}

/// Home Page Screen widget is the main page
/// of the app that renders [Month] and [PreferanceButton] widgets
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int month;
  late int year;
  int index = 0;
  // bool _loading = false;
  // TODO: fetch data from database based.
  // using mock data for now
  // final List<Mood> moodList = new List<Mood>.from(mMoodList);

  // List photoList;
  @override
  void initState() {
    super.initState();
    month = DateTime.now().month;
    year = DateTime.now().year;
  }

  void onHorizontalDragEnd(c.DragEndDetails value) {
    if (value.primaryVelocity == null) return;
    if (value.primaryVelocity!.isNegative) {
      // Drags Left
      setState(() {
        year = getNextYear(month, year);
        month = getNextMonth(month, year);
        index < 28 ? index += 1 : index = 0;
      });
    } else if (value.primaryVelocity! > 0) {
      // Drags Right
      setState(() {
        year = getPreviousYear(month, year);
        month = getPreviousMonth(month, year);
        index > 0 ? index -= 1 : index = 28;
      });
    }
    // else velocity is zero, no need to do anything
  }

  @override
  Widget build(BuildContext context) {
    // set the brightness on status bar
    SystemChrome.setSystemUIOverlayStyle(
        (brightness == Brightness.dark) ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

    return Stack(
      children: [
        Container(
          color: c.Color(0xFF80C0DB),
        ),
        BackgroundImage(month: month),
        c.CupertinoPageScaffold(
          backgroundColor: Color(0xFF80C0DB),
          // navigationBar: c.CupertinoNavigationBar(
          //   heroTag: 'HomePage',
          //   brightness: brightness,
          //   transitionBetweenRoutes: false,
          //   backgroundColor: Color(0x00000000),
          //   trailing: YearButton(),
          //   border: null,
          //   automaticallyImplyLeading: false,
          // ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 44,
                ),
                Container(
                  child: c.GestureDetector(
                    onHorizontalDragEnd: onHorizontalDragEnd,
                    child: Container(
                      padding: const c.EdgeInsets.symmetric(horizontal: 12),
                      child: Month(
                        month: month,
                        year: year,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class YearButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return c.CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pushNamed('year');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[
          const Padding(padding: EdgeInsetsDirectional.only(start: 8.0)),
          Text('Year'),
          const Padding(padding: EdgeInsetsDirectional.only(start: 6.0)),
        ],
      ),
    );
  }
}
