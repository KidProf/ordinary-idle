import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:restart_app/restart_app.dart';

class Settings extends StatelessWidget {
  final Secrets pSecrets;
  const Settings(this.pSecrets, {Key? key}) : super(key: key);

  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Wrap(
        children: [
          // const SizedBox(height: 70),
          const Text(
            'Settings',
            style: titleStyle,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
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
          ),
          ElevatedButton(
            onPressed: () async {
              //Delete Hive storage related to secrets
              await Hive.box('player').put("completedSecrets", <int>[]);
              await Hive.box('currentSecrets').clear();
              //Initialize deleted boxes
              await Hive.openBox('currentSecrets');
              RestartWidget.restartApp(context);
            },
            child: Text("Reset Secerets Only"),
          ),
        ],
        spacing: 30,
        runAlignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
