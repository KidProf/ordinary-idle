import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flame/src/device.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ordinary_idle/model/CurrentSecretV1.dart';

import 'package:ordinary_idle/pages/Home.dart';
import 'package:ordinary_idle/pages/Achievements.dart';
import 'package:ordinary_idle/pages/SecretsPage.dart';
import 'package:ordinary_idle/pages/Settings.dart';

import 'package:ordinary_idle/partials/ValueHeader.dart';

import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:ordinary_idle/util/toast.dart';

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
  Hive.registerAdapter(CurrentSecretV1Adapter());
  await Hive.openBox('player');
  await Hive.openBox('currentSecrets');

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
  final Money pMoney = Money();
  final Secrets pSecrets = Secrets();
  late final List<Widget> _widgetOptions = <Widget>[
    Home(pSecrets, pMoney.addCoins),
    Achievements(pSecrets),
    SecretsPage(pSecrets),
    Settings(pSecrets),
  ];
  int _selectedIndex = 0;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 2 && !pSecrets.secretCompleted(1)) {
      pSecrets.progressSecret(1, 0);
      final tuple = pSecrets.secretProgress(1);
      final isFinished = tuple.item1;
      final progress = tuple.item2;
      if (isFinished) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        fToast.removeCustomToast();
        MyToast.showBottomToast(fToast, progress < 10 ? "It is a secret" : "${20 - progress} steps to fun");
        // Fluttertoast.showToast(
        //   msg: progress < 10 ? "It is a secret" : "${20 - progress} steps to fun",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.black87,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      }
    } else {
      setState(() {
        _selectedIndex = index;
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
              preferredSize: const Size.fromHeight(50),
              child: ValueListenableBuilder<double>(
                  valueListenable: pMoney.getCoinsListener,
                  builder: (ctx, coins, _) {
                    // print("update");
                    return AppBar(
                        title: ValueHeader(
                      pCoins: coins,
                    ));
                  }))
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
        onTap: (int x) => _onItemTapped(x, context),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
