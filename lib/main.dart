import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flame/src/device.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/MyApp.dart';

import 'package:ordinary_idle/model/CurrentSecretV1.dart';

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

