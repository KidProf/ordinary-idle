import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';

import 'package:ordinary_idle/util/CustomIcons.dart';

import 'package:ordinary_idle/pages/Home.dart';
import 'package:ordinary_idle/pages/AchievementsPage.dart';
import 'package:ordinary_idle/pages/SecretsPage.dart';
import 'package:ordinary_idle/pages/Settings.dart';

import 'package:ordinary_idle/partials/ValueHeader.dart';

import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:ordinary_idle/data/Shops.dart';

// import 'partials/1cookie.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'OrdinaryIdle';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
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
  late Player p;
  late final List<Widget> _widgetOptions = <Widget>[
    Home(p),
    SecretsPage(p),
    AchievementsPage(p),
    Settings(p, _onItemTapped),
  ];
  int _selectedIndex = 0;
  int developerSecretProgress = 0;
  late FToast fToast;
  late Timer? idleTimer;
  Timer? developerSecretResetTimer;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    p = Player(fToast);
    //initialize idle timer
    idleTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      p.addIdleCoins();
    });
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 1 && !p.secretCompleted(1)) {
      developerSecretProgress+=1;
      developerSecretResetTimer?.cancel();
      developerSecretResetTimer = Timer(Duration(seconds: 15),(){
          print("timer fired, reset progress of developer secret");
          developerSecretProgress = 0;
      });
      if(developerSecretProgress==8){
        p.progressSecret(1, 0);
      }else if(developerSecretProgress >=3){
        fToast.removeCustomToast();
        MyToast.showBottomToast(fToast, "You are now ${8 - developerSecretProgress} steps away from revealing a secret");
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  // child: ValueListenableBuilder<Box>(
  //               valueListenable: Hive.box('player').listenable(),
  //               builder: (ctx, box, _) {
  //                 return AppBar(
  //                   title: ValueHeader(pCoins: box.get("pCoins")),
  //                 );
  //               },
  //             )
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3
          ? PreferredSize(
              preferredSize: const Size.fromHeight(
                  80), //! Please change CookieBackground to match the height of the header (specified in MyApp.dart)
              child: ValueListenableBuilder<Map<String, dynamic>>(
                  valueListenable: p.getVitalsListener,
                  builder: (ctx, vitals, _) {
                    // print("update");
                    return AppBar(
                      title: ValueHeader(
                        vitals,
                        _selectedIndex,
                      ),
                      toolbarHeight:
                          80, //! Please change CookieBackground to match the height of the header (specified in MyApp.dart)
                    );
                  }))
          : null,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock, size: 25),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.trophy, size: 20),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 25),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (int x) => _onItemTapped(x, context),
      ),
    );
  }

  @override
  void dispose() {
    idleTimer?.cancel();
    developerSecretResetTimer?.cancel();
    super.dispose();
  }
}
