import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/model/Config.dart';

import 'package:ordinary_idle/util/CustomIcons.dart';

import 'package:ordinary_idle/pages/Home.dart';
import 'package:ordinary_idle/pages/AchievementsPage.dart';
import 'package:ordinary_idle/pages/SecretsPage.dart';
import 'package:ordinary_idle/pages/Settings.dart';

import 'package:ordinary_idle/partials/ValueHeader.dart';

import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:ordinary_idle/data/Shops.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

class _MyStatefulWidgetState extends State<MyStatefulWidget> with WidgetsBindingObserver {
  late Player p;
  late final List<Widget> _widgetOptions = <Widget>[
    Home(p),
    SecretsPage(p),
    AchievementsPage(p, _onItemTapped),
    Settings(p, _onItemTapped),
  ];
  AppLifecycleState? _appState; //

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

    //check if app running in foreground
    WidgetsBinding.instance?.addObserver(this);

    //initialize ftoast
    fToast = FToast();
    fToast.init(context);

    //initialize player
    p = Player(fToast, _addAlert);

    //alert user to open secrets page if they haven't complete secret 0.1
    if (!p.secretCompleted(17)) {
      _addAlert(1);
    }

    //show notification, update data in config model
    if (!kIsWeb) {
      _updateConfig();
    }

    //enable idle timer, calculate offline income
    _resumeApp();
  }

  @override
  void dispose() {
    _pauseApp();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        _resumeApp();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        _pauseApp();
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        _pauseApp();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        _pauseApp();
        break;
    }
  }

  void _resumeApp() {
    //initialize idle timer
    idleTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      p.addIdleCoins();
    });

    //calculate offline income
    if (!kIsWeb) {
      final incomeTimeDiff =
          Config.lastIncomeTime() != null ? DateTime.now().difference(Config.lastIncomeTime()!) : Duration(days: 0);

      if (incomeTimeDiff.compareTo(const Duration(seconds: 5)) > 0 && p.computeCoinsPerSecond() != 0) {
        //5 seconds of cooldown in case for immediate restart/ immediate return to the app

        final offlineCoins =
            p.computeCoinsPerSecond() * min(7200, incomeTimeDiff.inSeconds); //max offline income 2 hours
        p.addCoins(offlineCoins);
        Functions.showMyDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          child: AlertDialog(
            title: const Text('While you are away...'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You are offline for ${Functions.printDuration(incomeTimeDiff)} and you earned $offlineCoins coins! (max offline income 2 hours)'),
                ],
              ),
            ),
            actions: [
              Row(
                children: [
                  ElevatedButton(
                    child: const Text('Great!'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
          ),
        );
      }
      Config.updateLastIncomeTime(DateTime
          .now()); //setting last income to a more recent time, as a precaution so that income won't get double counted
    }
  }

  void _pauseApp() {
    idleTimer?.cancel();
    developerSecretResetTimer?.cancel();
    stayHereSecretTimer?.cancel();
    Config.updateLastIncomeTime(DateTime.now());
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
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3
          ? PreferredSize(
              preferredSize: const Size.fromHeight(
                  80), //! Please change CookieBackground to match the height of the header (specified in MyApp.dart)
              child: ValueListenableBuilder<Map<String, dynamic>>(
                  valueListenable: p.getVitalsListener,
                  builder: (ctx, _, __) {
                    // print("update");
                    return AppBar(
                      title: ValueHeader(
                        p,
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

  Future<void> _updateConfig() async {
    //display notification if necessary
    String lastOpenedVersion = Config.lastOpenedVersion();

    //update info in config
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;

    final logonTimeDiff =
        Config.lastLogonTime() != null ? DateTime.now().difference(Config.lastLogonTime()!) : Duration(days: 0);

    final incomeTimeDiff =
        Config.lastIncomeTime() != null ? DateTime.now().difference(Config.lastIncomeTime()!) : Duration(days: 0);

    print(
        "timeSinceLastLogon: $logonTimeDiff, timeSinceLastIncome: $incomeTimeDiff, lastOpenedVersion: $lastOpenedVersion");

    //lastOpenedVersion == "" ==> first logon / from versions <=20
    if (lastOpenedVersion != buildNumber && buildNumber == "23") {
      //for internal testers, with prestige functionality
      Functions.showMyDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        child: AlertDialog(
          title: const Text('Progress Reset'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Thank you for trying the game! Unfortunately the progress for all players are reset in this version, as the data structure has changed a lot during the implementation of prestige and offline income. To compensate for this, there is a temporary button that adds 1e7 coins to your progress (in Settings page) so that you could try out the new prestige function (in Achievements page) immediately.'),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          ],
        ),
      );
    }

    Config.updateLastOpenedVersion(buildNumber);
    Config.updateLastLogonTime(DateTime.now());
  }
}
