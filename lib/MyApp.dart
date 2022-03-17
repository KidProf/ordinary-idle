import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ordinary_idle/pages/Home.dart';
import 'package:ordinary_idle/pages/Achievements.dart';
import 'package:ordinary_idle/pages/SecretsPage.dart';
import 'package:ordinary_idle/pages/Settings.dart';

import 'package:ordinary_idle/partials/ValueHeader.dart';

import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:ordinary_idle/util/Shops.dart';

// import 'partials/1cookie.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'OrdinaryIdle';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
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
  final Money pMoney = Money();
  late Secrets pSecrets;
  late Shops pShops = Shops(pMoney);
  late final List<Widget> _widgetOptions = <Widget>[
    Home(pSecrets, pMoney),
    SecretsPage(pSecrets),
    // Achievements(pSecrets),
    Settings(pSecrets),
  ];
  int _selectedIndex = 0;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    pSecrets = Secrets(pMoney.updateSecretsMultiplier, fToast);
  }

  void _onItemTapped(int index, BuildContext context) {
    if (index == 1 && !pSecrets.secretCompleted(1)) {
      pSecrets.progressSecret(1, 0);
      final tuple = pSecrets.secretProgress(1);
      final isFinished = tuple.item1;
      final progress = tuple.item2;

      fToast.removeCustomToast();
      if (isFinished) {
        setState(() {
          _selectedIndex = index;
        });
      } else {
        if (progress <= 3) {
          MyToast.showBottomToast(fToast, "This is a secret");
        } else if (progress <= 6) {
          MyToast.showBottomToast(fToast, "I said, THIS IS A SECRET!");
        } else if (progress <= 9) {
          MyToast.showBottomToast(fToast, "You will NEVER be able to get in");
        } else {
          MyToast.showBottomToast(fToast, "You are now ${15 - progress} steps away from revealing the secret");
        }
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
      appBar: _selectedIndex != 2 //TODO: Change back to 3 later
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ValueListenableBuilder<Map<String, dynamic>>(
                  valueListenable: pMoney.getMoneyListener,
                  builder: (ctx, money, _) {
                    // print("update");
                    return AppBar(
                      title: ValueHeader(
                        pCoins: money["coins"],
                        pMultiplier: money["multiplier"],
                      ),
                    );
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
            icon: Icon(Icons.lock),
            label: "",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.assignment_turned_in),
          //   label: "",
          // ),
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

  // @override
  // void dispose() {
  //   Hive.close();
  //   super.dispose();
  // }
}
