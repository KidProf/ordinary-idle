import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flame/src/device.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/model/PlayerV1.dart';

import 'package:ordinary_idle/pages/Home.dart';
import 'package:ordinary_idle/pages/Achievements.dart';
import 'package:ordinary_idle/pages/Secrets.dart';
import 'package:ordinary_idle/pages/Settings.dart';

import 'package:ordinary_idle/partials/HomeHeader.dart';

// import 'package:flame/src/game/game_widget/game_widget.dart';
// import 'partials/1cookie.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //It will usually be bugged if you are awaiting on main() method without this line of code.

  //Initialize Flame
  var flameDevice = Device();
  await flameDevice.fullScreen();
  await flameDevice.setOrientation(DeviceOrientation.portraitUp);

  //Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerV1Adapter());
  await Hive.openBox<PlayerV1>('player');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'OrdinaryIdle';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    Home(),
    const Achievements(),
    const Secrets(),
    const Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: HomeHeader(pCoins: 4096),
            )
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
