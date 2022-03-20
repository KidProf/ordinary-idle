import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:ordinary_idle/util/Util.dart';
import 'package:restart_app/restart_app.dart';

class Settings extends StatelessWidget {
  final Secrets pSecrets;
  final Money pMoney;
  final Function(int, BuildContext) onItemTapped;
  const Settings(this.pSecrets, this.pMoney, this.onItemTapped, {Key? key}) : super(key: key);

  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Wrap(
            children: [
              const Text(
                'Settings',
                style: titleStyle,
              ),
              const Text(
                'Danger Zone',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                    "Note that these actions cannot be undone. The reset secrets only button is only temporary available during beta stage."),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Row(
                  children: [
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
                      child: Text("Reset Secrets Only"),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Expanded(child: Divider(color: Colors.black45)),
              ),
              const Text(
                'Change Theme',
                style: titleStyle,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                    "Changing themes unlock the possibility of finding different secrets. Reach 1e6 coins net worth to unlock the option of changing themes. Although there will only be a few during beta stage, expect to see more as we are approaching release."),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            pMoney.getNetWorth() >= 1000000 ? Colors.green : Util.disabled),
                      ),
                      onPressed: () async {
                        if (pMoney.getNetWorth() >= 1000000) {
                          //1e6
                          await _changeTheme(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Reach 1e6 coins net worth to unlock the option of changing themes. ");
                        }
                      },
                      child: Text("Change Theme"),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width - 20, height: 0), //maintain width and top padding
            ],
            spacing: 20,
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.vertical,
          ),
        ),
      ),
    );
  }

  Future<void> _resetAll(BuildContext context) async {
    //Delete Hive
    await Hive.box('player').clear();
    await Hive.box('currentSecretsV2').clear();
    await Hive.box('purchases').clear();
    //Initialize Hive
    await Hive.openBox('player');
    await Hive.openBox('currentSecretsV2');
    await Hive.openBox('purchases');
    RestartWidget.restartApp(context);
  }

  Future<void> _resetSecretsOnly(BuildContext context) async {
    //Delete Hive storage related to secrets
    await Hive.box('player').put("completedSecrets", <int>[]);
    await Hive.box('player').put("currentTheme", 1);
    await Hive.box('player').put("unlockedThemes", <int>[1]);
    await Hive.box('currentSecretsV2').clear();

    //Initialize deleted boxes
    await Hive.openBox('currentSecretsV2');
    RestartWidget.restartApp(context);
  }

  Future<void> _changeTheme(BuildContext context) async {
    final numberOfThemes = 2; //TODO: change when number of themes increases
    var player = Hive.box('player');
    await player.put("unlockedThemes", <int>[1, 2]); //TODO: temp, so that all themes are unlocked without constraints

    var currentTheme = player.get("currentTheme", defaultValue: 1);
    var unlockedThemes = player.get("unlockedThemes", defaultValue: <int>[1]);
    var newTheme =
        unlockedThemes[(unlockedThemes.indexOf(currentTheme) + 1) % unlockedThemes.length]; //cycle to the next theme
    player.put('currentTheme', newTheme);
    RestartWidget.restartApp(context);
    onItemTapped(0, context); //switch to home page
  }
}
