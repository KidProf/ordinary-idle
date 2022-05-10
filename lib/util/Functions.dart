import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ordinary_idle/data/Achievements.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/model/PlayerT1.dart';
import 'package:ordinary_idle/model/PlayerT2.dart';
import 'package:ordinary_idle/util/Modules.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

mixin Functions {
  static String doubleRepresentation(double value) {
    if (value < 1000) {
      //10^3
      final f = NumberFormat("##0.00", "en_GB");
      return f.format(_roundDouble(value, 2));
    } else if (value < 100000) {
      //10^5
      final f = NumberFormat("##0", "en_GB");
      return f.format(_roundDouble(value, 0));
    } else {
      return value
          .toStringAsExponential(3)
          .runes
          .where((int c) => c != 43)
          .map((int c) => String.fromCharCode(c))
          .join();
      //to remove the + sign (with ASCII = 43), but complications emerge when converting from strings to list of characters and vice versa
    }
  }

  static double _roundDouble(double value, int places) {
    double mod = pow(10.0, 2).toDouble(); // 2 dp for now
    return (value * mod).round().toDouble() / mod;
  }

  static void launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  static Future<void> showMyDialog({
    required AlertDialog child,
    required BuildContext context,
    bool barrierDismissible = true, // false: user must tap button!
  }) async {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  static Future<void> showMultiplierDialog({
    required Player p,
    bool newPrestigeMultiplier = false,
    required List<Map<String, dynamic>> actions, //String "text", Function "action", Color "color"
    required BuildContext context,
    String? extraMessage,
  }) async {
    showMyDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Multipliers'),
        content: SingleChildScrollView(
          child: ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: p.getVitalsListener,
              builder: (ctx, _, __) {
                List<Widget> children = [];

                var multipliers = p.getMulitpliers();

                if (!newPrestigeMultiplier) {
                  double totalMultiplier =
                      multipliers.keys.map((String key) => multipliers[key]).fold(1.0, (xs, x) => xs * x!);
                  children = [
                    ...multipliers.keys
                        .map((String key) => Row(
                              children: [
                                Text(key + ":"),
                                Text("x" + doubleRepresentation(multipliers[key]!)),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ))
                        .toList(),
                    Modules.divider(),
                    Row(
                      children: [
                        Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("x" + doubleRepresentation(totalMultiplier),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ];
                } else {
                  final newMultipliers = {"Prestige": p.computePrestigeMultiplier()};
                  double totalMultiplier =
                      multipliers.keys.map((String key) => multipliers[key]).fold(1.0, (xs, x) => xs * x!);
                  double multiplier1 = multipliers.keys
                      .where((String key) => !newMultipliers.containsKey(key))
                      .map((String key) => multipliers[key])
                      .fold(1.0, (xs, x) => xs * x!);
                  double multiplier2 =
                      newMultipliers.keys.map((String key) => newMultipliers[key]).fold(1.0, (xs, x) => xs * x!);
                  double newTotalMultiplier = multiplier1 * multiplier2;

                  children = [
                    ...multipliers.keys
                        .map((String key) => Row(
                              children: [
                                Text(key + ":"),
                                Text("x" + doubleRepresentation(multipliers[key]!)),
                                Text(
                                  "x" +
                                      doubleRepresentation(
                                          newMultipliers.containsKey(key) ? newMultipliers[key]! : multipliers[key]!),
                                  style: newMultipliers.containsKey(key)
                                      ? (newMultipliers[key]! > multipliers[key]!
                                          ? TextStyle(color: Colors.green)
                                          : TextStyle(color: Colors.red))
                                      : null,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ))
                        .toList(),
                    Modules.divider(),
                    Row(
                      children: [
                        Text("Total:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("x" + doubleRepresentation(totalMultiplier),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("x" + doubleRepresentation(newTotalMultiplier),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ];
                }

                if (extraMessage != null) {
                  children.add(SizedBox(height: 30));
                  children.add(Text(extraMessage));
                }
                return ListBody(
                  children: children,
                );
              }),
        ),
        actions: [
          Row(
            children: actions
                .map(
                  (a) => ElevatedButton(
                    child: Text(a["text"] ?? "Close"),
                    onPressed: a["action"] ??
                        () {
                          Navigator.of(context).pop();
                        },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(a["color"] ?? Colors.blue),
                    ),
                  ),
                )
                .toList(),
            mainAxisAlignment: actions.length == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          )
        ],
      ),
    );
  }

  static bool prestigeCriteria(double mMax, double prevMMax) {
    // print("mMax: $mMax, prevMMax: $prevMMax");
    return mMax >= 10000000 && mMax >= prevMMax;
    //1e7 and higher than last prestige
  }

  //TODO
  static void changeTheme(BuildContext context, Function(int, BuildContext) onItemTapped) {
    var visitedThemes = PlayerT2.visitedThemes();
    final availableThemes = [1, 2, 3]; //!: change when number of themes increases
    final currentTheme = PlayerT2.currentTheme();
    var newTheme =
        availableThemes[(availableThemes.indexOf(currentTheme) + 1) % availableThemes.length]; //cycle to the next theme

    if (!visitedThemes.contains(newTheme)) {
      PlayerT2.updateVisitedThemes(<int>[...visitedThemes, newTheme]);
    }
    print(visitedThemes);
    PlayerT2.updateCurrentTheme(newTheme);

    //restarting of the whole app, so what we just save everything to hive then its fine (so that the variables e.g. money you have, will be reset)
    RestartWidget.restartApp(context);
    onItemTapped(0, context); //switch to home page
  }

  //TODO
  static Future<void> prestige(Player p, BuildContext context, Function(int, BuildContext) onItemTapped) async {
    //assertion on criteria before continuing
    if (!prestigeCriteria(p.getMMax(), p.getPrevMMax())) {
      Fluttertoast.showToast(msg: "Not prestiged: Criteria not met");
      return;
    }

    //update multiplier
    PlayerT2.updatePrestigeMultiplier(p.computePrestigeMultiplier());

    //save mmax when prestige
    PlayerT2.updatePrevMMax(p.getMMax());

    //TODO: Toast not seen because of app restart (maybe put the information that we need to show the toast to Hive)
    //increase 1 for prestige achievement
    p.incrementAchievementParam("prestige");

    //reset everything in tier 1 player box
    await PlayerT1.getBox().clear();

    //Initialize deleted boxes
    await Hive.openBox(PlayerT1.boxString);

    //reset purchases
    await Hive.box('purchases').clear();

    //change theme
    //it will also invoke restarting of the whole app, so what we just save everything to hive then its fine
    changeTheme(context, onItemTapped);
  }
}
