import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/MyApp.dart';
import 'package:ordinary_idle/model/Config.dart';

import 'package:ordinary_idle/model/CurrentSecretV2.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //It will usually be bugged if you are awaiting on main() method without this line of code.

  //Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CurrentSecretV2Adapter());

  if (kIsWeb) {
    //reset everytime to prevent weird bugs
    Hive.deleteFromDisk();
  }


  await Hive.openBox('player');

  await Hive.openBox("config");

  await Hive.openBox('currentSecretsV2');
  await Hive.openBox('purchases');

  if (kIsWeb) {
    //clear all data to prevent it from crashing
    await Hive.box('player').clear();
    await Hive.box("config").clear();
    await Hive.box('currentSecretsV2').clear();
    await Hive.box('purchases').clear();

    //set current theme to cookie for best experience on web
    Hive.box("player").put("visitedThemes", <int>[3]);
    Hive.box("player").put("currentTheme", 3);
  }

  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
