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
  const Settings(this.pSecrets, this.pMoney, this.onItemTapped, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Util.WarpBody(
        context: context,
        children: [
          const Text(
            'Settings',
            style: Util.titleStyle,
          ),
          const Text(
            'Danger Zone',
            style: TextStyle(fontSize: 30, color: Colors.red),
          ),
          Text(
              "Note that these actions cannot be undone. The reset secrets only button is only temporary available during beta stage."),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    // barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Reset All'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text(
                                  'Would you like reset all your progress? This process cannot be undone.'),
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              ElevatedButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    await _resetAll(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.red,
                                    ),
                                  )),
                              ElevatedButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text("Reset All"),
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    // barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Reset Secrets Only'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const <Widget>[
                              Text(
                                  'Would you like reset your secrets? This process cannot be undone.'),
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              ElevatedButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    await _resetSecretsOnly(context);
                                  },
                                  ),
                              ElevatedButton(
                                child: const Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          )
                        ],
                      );
                    },
                  );
                  
                },
                child: Text("Reset Secrets Only"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Util.divider(),
          const Text(
            'Change Theme',
            style: Util.subtitleStyle,
          ),
          Text(
              "Changing themes unlock the possibility of finding different secrets. Reach 1e6 coins net worth to unlock the option of changing themes. Although there will only be a few during beta stage, expect to see more as we are approaching release."),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      pMoney.getNetWorth() >= 1000000
                          ? Colors.green
                          : Util.disabled),
                ),
                onPressed: () async {
                  if (pMoney.getNetWorth() >= 1000000) {
                    //1e6
                    await _changeTheme(context);
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            "Reach 1e6 coins net worth to unlock the option of changing themes. ");
                  }
                },
                child: Text("Change Theme"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
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
    await player.put("unlockedThemes", <int>[
      1,
      2
    ]); //TODO: temp, so that all themes are unlocked without constraints

    var currentTheme = player.get("currentTheme", defaultValue: 1);
    var unlockedThemes = player.get("unlockedThemes", defaultValue: <int>[1]);
    var newTheme = unlockedThemes[(unlockedThemes.indexOf(currentTheme) + 1) %
        unlockedThemes.length]; //cycle to the next theme
    player.put('currentTheme', newTheme);
    print("PLAYER GET" + player.get("coins").toString());
    RestartWidget.restartApp(context);
    print("PLAYER GET" + player.get("coins").toString());
    onItemTapped(0, context); //switch to home page
  }
}
