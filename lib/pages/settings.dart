import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:restart_app/restart_app.dart';

class Settings extends StatelessWidget {
  final Secrets pSecrets;
  final Function(int,BuildContext) onItemTapped;
  const Settings(this.pSecrets, this.onItemTapped, {Key? key}) : super(key: key);

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
              await _resetAll(context);
            },
            child: Text("Reset All"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _resetSecretsOnly(context);
            },
            child: Text("Reset Secerets Only"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            onPressed: () async {
              await _changeTheme(context);
            },
            child: Text("Change Theme"),
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

  Future<void> _resetAll(BuildContext context) async {
    //Delete Hive
    await Hive.box('player').clear();
    await Hive.box('currentSecrets').clear();
    await Hive.box('purchases').clear();
    //Initialize Hive
    await Hive.openBox('player');
    await Hive.openBox('currentSecrets');
    await Hive.openBox('purchases');
    RestartWidget.restartApp(context);
  }

  Future<void> _resetSecretsOnly(BuildContext context) async {
    //Delete Hive storage related to secrets
    await Hive.box('player').put("completedSecrets", <int>[]);
    await Hive.box('player').put("currentTheme", 1);
    await Hive.box('player').put("unlockedThemes", <int>[1]);
    await Hive.box('currentSecrets').clear();
    //Initialize deleted boxes
    await Hive.openBox('currentSecrets');
    
  }

  Future<void> _changeTheme(BuildContext context) async {
    final numberOfThemes = 2; //TODO: change when number of themes increases
    var player = Hive.box('player');
    await player.put("unlockedThemes", <int>[1,2]); //TODO: temp, so that all themes are unlocked without constraints

    var currentTheme = player.get("currentTheme",defaultValue: 1);
    var unlockedThemes = player.get("unlockedThemes",defaultValue: <int>[1]);
    var newTheme = unlockedThemes[(unlockedThemes.indexOf(currentTheme)+1)%unlockedThemes.length]; //cycle to the next theme
    player.put('currentTheme',newTheme);
    RestartWidget.restartApp(context);
    onItemTapped(0,context); //switch to home page
  }
}
