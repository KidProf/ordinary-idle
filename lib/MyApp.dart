import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      theme: ThemeData(
        //varelaRoundTextTheme, latoTextTheme, nanumGothicTextTheme, openSansTextTheme
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
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
  List<int> _alerts = [];
  int developerSecretProgress = 0;
  late FToast fToast;
  late Timer? idleTimer;
  Timer? developerSecretResetTimer;
  Timer? stayHereSecretTimer;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    p = Player(fToast, _addAlert);

    //initialize idle timer
    idleTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      p.addIdleCoins();
    });

    //alert user to open secrets page if they haven't complete secret 0.1
    if (!p.secretCompleted(17)) {
      _addAlert(1);
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 1) {
      if (!p.secretCompleted(1)) {
        developerSecretProgress += 1;
        developerSecretResetTimer?.cancel();
        developerSecretResetTimer = Timer(Duration(seconds: 15), () {
          print("timer fired, reset progress of developer secret");
          developerSecretProgress = 0;
        });
        if (developerSecretProgress == 8) {
          p.progressSecret(1, 0);
        } else if (!p.secretCompleted(1) && developerSecretProgress >= 3) {
          fToast.removeCustomToast();
          MyToast.showBottomToast(
              fToast, "You are now ${8 - developerSecretProgress} steps away from revealing a secret");
        }
      }
      if (!p.secretCompleted(17)) {
        if (stayHereSecretTimer == null || !stayHereSecretTimer!.isActive) {
          stayHereSecretTimer = Timer(Duration(seconds: 5), () {
            p.progressSecret(17, 0);
          });
        }
      }
    }else{
      stayHereSecretTimer?.cancel();
    }
    setState(() {
      _selectedIndex = index;
      _alerts = _alerts.where((x) => x != index).toList();
    });
  }

  void _addAlert(int index) {
    if (!_alerts.contains(index) && !(index == _selectedIndex)) {
      setState(() {
        _alerts = [..._alerts, index];
      });
    }
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
        items: <BottomNavigationBarItem>[
          _BottomIcon(index: 0, iconData: Icons.home, size: 30),
          _BottomIcon(index: 1, iconData: Icons.lock, size: 25),
          _BottomIcon(index: 2, iconData: CustomIcons.trophy, size: 20),
          _BottomIcon(index: 3, iconData: Icons.settings, size: 25),
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
    stayHereSecretTimer?.cancel();
    super.dispose();
  }

  BottomNavigationBarItem _BottomIcon({required int index, required IconData iconData, required double size}) {
    return BottomNavigationBarItem(
      icon: Container(
        height: 40,
        width: 40,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Icon(iconData, size: size),
              top: (40 - size) / 2,
              left: (40 - size) / 2,
            ),
            _alerts.contains(index)
                ? Positioned(
                    // draw a red marble
                    top: 0.0,
                    right: 0.0,
                    child: Icon(Icons.brightness_1, size: 12.0, color: Colors.redAccent),
                  )
                : SizedBox(),
          ],
        ),
      ),
      label: "",
    );
  }
}
