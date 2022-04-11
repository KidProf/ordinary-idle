import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/util/Util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

class Settings extends StatelessWidget {
  final Player p;
  final Function(int, BuildContext) onItemTapped;
  const Settings(this.p, this.onItemTapped, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Util.WarpBody(
        context: context,
        children: [
          const SizedBox(height: 30),
          const Text(
            'Settings',
            style: Util.titleStyle,
          ),
          const Text(
            'Danger Zone',
            style: TextStyle(fontSize: 25, color: Colors.red),
          ),
          Text(
              "Note that these actions cannot be undone. The reset secrets only button is only temporary available during development stage."),
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
                              Text('Would you like reset all your progress? This process cannot be undone.'),
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
                                    backgroundColor: MaterialStateProperty.all<Color>(
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
                              Text('Would you like reset your secrets? This process cannot be undone.'),
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
              "Changing themes unlock the possibility of finding different secrets. Reach 1e6 coins net worth to unlock the option of changing themes. Although there will only be a few during development stage, expect to see more as we are approaching release."),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(p.getNetWorth() >= 1000000 ? Colors.green : Util.disabled),
                ),
                onPressed: () async {
                  //! CRACK: do not put this to release!!!
                  if (p.getNetWorth() >= 1000000) {
                  //1e6
                  await _changeTheme(context);
                  } else {
                    Fluttertoast.showToast(msg: "Reach 1e6 coins net worth to unlock the option of changing themes. ");
                  }
                },
                onLongPress: () async {
                  Fluttertoast.showToast(msg: "This is a temporary function for us to switch between themes easily.");
                  await _changeTheme(context);
                },
                child: Text("Change Theme"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Util.divider(),
          const Text(
            'Abouts',
            style: Util.subtitleStyle,
          ),
          Text(
              "Thank you for joining the beta test. This game is to test out the idea of fusing an idle game with some puzzle-solving components.\n\nDon't be too stressed not being able to find the secrets, as they are supposed to be difficult. You will eventually find some as you progress more and earn more money. The in-game hints system which would be introduced in the future would also definitely help. For now, if you desperately get stuck, you could join our Discord server and discuss.\n\nI am well aware that the number of secrets it has right now is not enough for players to engage long-term, but it will slowly be increasing as time goes by, especially with the support and feedback from players. \n\nOrdinaryIdle is currently in its very early stage of development, there would possibly be bugs or something that is not done very well. If there is something you would like to voice out, you could join our Discord server."),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 88, 101, 242)),
                ),
                onPressed: () async {
                  Util.launchURL("https://discord.gg/G3MsQFzSFe");
                },
                child: Text("Discord Invite Link"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          FutureBuilder(future: () async {
            PackageInfo packageInfo = await PackageInfo.fromPlatform();

            // String appName = packageInfo.appName;
            // String packageName = packageInfo.packageName;
            String version = packageInfo.version;
            String buildNumber = packageInfo.buildNumber;
            return Tuple2(version, buildNumber);
          }(), builder: (context, AsyncSnapshot<Tuple2<String, String>> snapshot) {
            if (snapshot.hasData) {
              return Text("Created by KidProf with Flutter\nVersion: " +
                  snapshot.data!.item1 +
                  "\nBuild Number: " +
                  snapshot.data!.item2);
            } else {
              return Text("Created by KidProf with Flutter");
            }
          }),
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
    await Hive.box('player').put("visitedThemes", <int>[1]);
    await Hive.box('currentSecretsV2').clear();

    //Initialize deleted boxes
    await Hive.openBox('currentSecretsV2');
    RestartWidget.restartApp(context);
  }

  Future<void> _changeTheme(BuildContext context) async {
    var player = Hive.box('player');
    var visitedThemes = player.get("visitedThemes", defaultValue: <int>[1]);
    final availableThemes = [1, 2, 3]; //TODO: change when number of themes increases
    final currentTheme = player.get("currentTheme", defaultValue: 1);
    var newTheme =
        availableThemes[(availableThemes.indexOf(currentTheme) + 1) % availableThemes.length]; //cycle to the next theme

    if (!visitedThemes.contains(newTheme)) {
      player.put("visitedThemes", <int>[...visitedThemes, newTheme]);
    }
    print(visitedThemes);
    player.put('currentTheme', newTheme);
    RestartWidget.restartApp(context);
    onItemTapped(0, context); //switch to home page
  }
}
