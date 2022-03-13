import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:restart_app/restart_app.dart';

class Settings extends StatelessWidget {
  final Secrets pSecrets;
  const Settings(this.pSecrets, {Key? key}) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Settings',
            style: optionStyle,
          ),
          ElevatedButton(
            onPressed: () async {
              //Delete Hive
              // Hive.deleteFromDisk();
              await Hive.box('player').clear();
              await Hive.box('currentSecrets').clear();
              //Initialize Hive
              await Hive.openBox('player');
              await Hive.openBox('currentSecrets');
              RestartWidget.restartApp(context);
            },
            child: Text("Reset All"),
          )
        ]);
  }
}
