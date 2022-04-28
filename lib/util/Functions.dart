import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ordinary_idle/main.dart';
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

  static Future<void> changeTheme(BuildContext context, Function(int, BuildContext) onItemTapped) async {
    var player = Hive.box('player');
    var visitedThemes = player.get("visitedThemes", defaultValue: <int>[1]);
    final availableThemes = [1, 2, 3]; //!: change when number of themes increases
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

  static Future<void> showMultiplierDialog(
    Map<String, double> multipliers,
    Map<String, double> newMultipliers,
    List<Map<String, dynamic>> actions, //String "text", Function "action", Color "color"
    BuildContext context,
    {String? extraMessage}
  ) async {
    List<Widget> children = [];
    if (newMultipliers.isEmpty) {
      double totalMultiplier = multipliers.keys.map((String key)=> multipliers[key]).fold(1.0,(xs, x) => xs * x!);
      children = [...multipliers.keys
          .map((String key) => Row(
                children: [
                  Text(key+":"),
                  Text("x"+doubleRepresentation(multipliers[key]!)),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ))
          .toList(),
          Modules.divider(),
          Row(
                children: [
                  Text("Total:",style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("x"+doubleRepresentation(totalMultiplier),style: TextStyle(fontWeight: FontWeight.bold)),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          ];
    } else {
      double totalMultiplier = multipliers.keys.map((String key)=> multipliers[key]).fold(1.0,(xs, x) => xs * x!);
      double multiplier1 = multipliers.keys.where((String key)=> !newMultipliers.containsKey(key)).map((String key)=> multipliers[key]).fold(1.0,(xs, x) => xs * x!);
      double multiplier2 = newMultipliers.keys.map((String key)=> newMultipliers[key]).fold(1.0,(xs, x) => xs * x!);
      double newTotalMultiplier = multiplier1*multiplier2;
      
      children = [...multipliers.keys
          .map((String key) => Row(
                children: [
                  Text(key+":"),
                  Text("x"+doubleRepresentation(multipliers[key]!)),
                  Text("x"+doubleRepresentation(newMultipliers.containsKey(key) ? newMultipliers[key]! : multipliers[key]!)),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ))
          .toList(),
          Modules.divider(),
          Row(
                children: [
                  Text("Total:",style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("x"+doubleRepresentation(totalMultiplier),style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("x"+doubleRepresentation(newTotalMultiplier),style: TextStyle(fontWeight: FontWeight.bold)),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          ];
    }

    if(extraMessage != null){
      children.add(SizedBox(height: 10));
      children.add(Text(extraMessage));
    }
    showDialog(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Multipliers'),
          content: SingleChildScrollView(
            child: ListBody(
              children: children,
            ),
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
        );
      },
    );
  }
}
