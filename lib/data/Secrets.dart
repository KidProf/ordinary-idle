import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV2.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:tuple/tuple.dart';

mixin Secrets {
  //INTERFACE
  double updateSecretsMultiplier();

  late FToast fToast;
  late Function addAlert;

  final Box player = Hive.box("player");
  final Box currentSecrets = Hive.box("currentSecretsV2");
  late List<dynamic> completedSecrets = player.get("completedSecrets", defaultValue: <int>[]);
  late List<dynamic> visitedThemes = player.get("visitedThemes", defaultValue: <int>[1]); //used in SecretsPage.dart
  late int currentTheme = player.get("currentTheme", defaultValue: 1);

  Map<int, CurrentVolatileSecret> currentVolatileSecrets = {};

  //ctor
  @protected
  void initSecrets(fToast, addAlert) {
    this.fToast = fToast;
    this.addAlert = addAlert;
  }

  //TODO: Gen from CSV
  static final secrets = [
    //referenced in:
    //MyApp.dart
    Secret(
      id: 1,
      exid: "0.2",
      prerequisites: [],
      title: "You are now a developer!",
      description: "Tapping the secret button 8 times.",
      theme: 0,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),

    //referenced in:
    // CookieBackground.dart
    Secret(
      id: 2,
      exid: "3.1",
      prerequisites: [],
      title: "More space to tap",
      description:
          "Tapping outside the cookie but inside the canvas 10 times.\n\nAs the cookie will move around and even change in size, I think making taps outside the cookie count is a good idea.",
      theme: 3,
      reward: 1.3,
      progressComponent: [
        {
          "total": 10,
          "volatile": false,
        },
      ],
    ),

    Secret(
      id: 3,
      exid: "3.2",
      prerequisites: [],
      title: "Where did it go?",
      description: "Swipe the cookie up until it disappears from the screen.",
      theme: 3,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 4,
      exid: "3.3",
      prerequisites: [3],
      title: "Diode",
      description: "Rotate the cookie anticlockwise for 4 cycles.",
      theme: 3,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 9999,
      exid: "2.0",
      prerequisites: [],
      title: "Number of taps",
      description: "",
      theme: 2,
      reward: 0.0,
      type: "hidden",
      progressComponent: [
        {
          "total": 10000, //now finite, because max value of it is now 1100 (cannot use infinity here because web breaks)
          "volatile": false,
        },
      ],
    ),
    Secret(
      id: 5,
      exid: "2.1",
      prerequisites: [],
      title: "69",
      description: "Invert the phone when the tap count only contains 6s and 9s.",
      theme: 2,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 6,
      exid: "2.2",
      prerequisites: [],
      title: "Change in perspective makes you feel better",
      description: "Invert the phone so that the number appears to be at least 700 larger than the actual number.",
      theme: 2,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 7,
      exid: "2.3",
      prerequisites: [],
      title: "Text Overflow",
      description:
          "Make the tap count overflowing the screen (or wider than 400 pixels in case you are using a tablet).",
      theme: 2,
      reward: 2.0,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 8,
      exid: "2.4",
      prerequisites: [],
      title: "Remain LOL",
      description: "Stop at 303, 505 or 707 for 5 seconds, which are replaced by LOL.",
      theme: 2,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 9,
      exid: "2.5",
      prerequisites: [],
      title: "There is an end",
      description:
          "Click until 1100, where it resets back to 0. You should be able to do all the secrets without tapping more than 1100. So think twice if you still haven't found some of them at this stage.",
      theme: 2,
      reward: 1.5,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 10,
      exid: "1.1",
      prerequisites: [],
      title: "Shake Shake",
      description: "Shake the soft drink",
      theme: 1,
      reward: 1.3,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 11,
      exid: "1.2",
      prerequisites: [],
      title: "Colourful",
      description: "Long tap the background to change colour",
      theme: 1,
      reward: 1.3,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 12,
      exid: "1.3",
      prerequisites: [],
      title: "Fanta",
      description: "Change the colour of the soft drink to orange.",
      theme: 1,
      reward: 1.3,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 13,
      exid: "1.4",
      prerequisites: [],
      title: "Ooh! Our competitor!",
      description: "Change the colour of the soft drink to blue (Pepsi).",
      theme: 1,
      reward: 1.3,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 14,
      exid: "1.5",
      prerequisites: [],
      title: "Discover all",
      description: "Discover all soft drinks in the game. (Cola, Fanta, Sprite, Pepsi, Fanta Grape)",
      theme: 1,
      reward: 1.5,
      progressComponent: [
        {
          "total": int.parse("11111", radix: 2),
          "volatile": false,
          "type": "bitmap",
        },
      ],
    ),
    Secret(
      id: 15,
      exid: "1.6",
      prerequisites: [],
      title: "Shake all",
      description: "Shake all soft drinks in the game. (Cola, Fanta, Sprite, Pepsi, Fanta Grape)",
      theme: 1,
      reward: 1.5,
      progressComponent: [
        {
          "total": int.parse("11111", radix: 2),
          "volatile": false,
          "type": "bitmap",
        },
      ],
    ),
    //referenced in:
    //HotbarShop.dart, DetailShop.dart: complete once user long press any purchase button with enough money
    Secret(
      id: 16,
      exid: "0.3",
      prerequisites: [],
      title: "Buy until bankrupt",
      description: "Long press any shop button to purcahse until you run out of money.",
      theme: 0,
      reward: 1.3,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    //referenced in:
    //MyApp.dart
    Secret(
      id: 17,
      exid: "0.1",
      prerequisites: [],
      title: "Stay here",
      description: "Stayed in the secrets page for 5 seconds.",
      theme: 0,
      reward: 1.3,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
  ];

  static final secretHeaders = {
    0: {
      "title": "General Secrets",
      "description": "Can be discovered no matter which theme you are in",
    },
    1: {
      "title": "Soft Drinks",
      "description": "Source of evil",
    },
    2: {
      "title": "Tap Count",
      "description": "A less graphic-intensive theme",
    },
    3: {
      "title": "Cookie",
      "description": "A remix of the classic cookie clicker",
    },
  };

  static Secret getSecretById(int id) {
    return secrets.where((s) => s.id == id).first;
  }

  static List<int> getSecretsByTheme(int theme) {
    var matches = secrets.where((s) => s.theme == theme).toList(); //list of matching secrets
    matches.sort((a, b) => a.exid.compareTo(b.exid));
    return matches.map((s) => s.id).toList(); //only extract their ids
  }

  bool secretDoable(int id) {
    final s = getSecretById(id);
    //if theme is 0, can be accessed anywhere
    if (s.theme != 0 && s.theme != currentTheme) return false;

    for (var prerequisite in s.prerequisites) {
      if (!secretCompleted(prerequisite)) return false;
    }
    return !secretCompleted(id);
  }

  bool secretCompleted(int id) {
    return completedSecrets.contains(id);
  }

  bool prerequisiteMet(int id) {
    final s = getSecretById(id);

    //if theme is 0, can be accessed anywhere
    if (s.theme != 0 && !visitedThemes.contains(s.theme)) return false;

    for (var prerequisite in s.prerequisites) {
      if (!secretCompleted(prerequisite)) return false;
    }
    return true;
  }

  Tuple2<bool, int> secretProgress(int id) {
    if (currentSecrets.containsKey(id)) {
      final CurrentSecretV2 c = currentSecrets.get(id);
      return Tuple2(false, c.progress);
    }
    if (currentVolatileSecrets.containsKey(id)) {
      final CurrentVolatileSecret cv = currentVolatileSecrets[id]!;
      return Tuple2(false, cv.progress);
    }
    if (secretCompleted(id)) {
      return Tuple2(true, 0); //completed already, so no need tracking OR prerequisite not met, cannot start
    }

    return Tuple2(false, 0);
    //return 0 if not in current list
  }

  void progressSecret(int id, int stage, {int amount = 1, bool isBitmap = false}) {
    print("entered progressSecret function with id: " + id.toString() + ", stage: " + stage.toString());
    if (secretCompleted(id) || !prerequisiteMet(id)) {
      return; //completed already, so no need tracking OR prerequisite not met, cannot start
    } else if (currentSecrets.containsKey(id)) {
      final CurrentSecretV2 c = currentSecrets.get(id);
      if (c.stage == stage) {
        //no progression if wrong stage, the ! is for null checking, which I think doesnt needed because we are sure it contains the key
        if (!isBitmap) {
          c.progress += amount;
        } else {
          c.progress = c.progress | pow(2, amount).toInt();
        }

        print("current progress: " + c.progress.toString());
        currentSecrets.put(id, c);
        if (c.progress >= c.total) {
          currentSecrets.delete(id);
          if (c.stage + 1 == c.totalStages) {
            _completeSecret(id);
          } else {
            _initNewSecret(id, c.stage + 1);
          }
        }
      }
    } else if (currentVolatileSecrets.containsKey(id)) {
      final CurrentVolatileSecret cv = currentVolatileSecrets[id]!;
      if (cv.stage == stage) {
        //no progression if wrong stage, the ! is for null checking, which I think doesnt needed because we are sure it contains the key
        if (!isBitmap) {
          cv.progress += amount;
        } else {
          cv.progress = cv.progress | pow(2, amount).toInt();
        }
        print("current progress (volatile): " + cv.progress.toString());
        if (cv.progress >= cv.total) {
          currentVolatileSecrets.remove(id);
          if (cv.stage + 1 == cv.totalStages) {
            _completeSecret(id);
          } else {
            _initNewSecret(id, cv.stage + 1);
          }
        }
      }
    } else {
      final s = getSecretById(id);
      if (s.progressComponent[0]["total"] > amount) {
        _initNewSecret(id, 0, amount: isBitmap ? pow(2, amount).toInt() : amount);
      } else if (s.progressComponent.length <= 1) {
        _completeSecret(id);
      } else {
        _initNewSecret(id, 1);
      }
    }
  }

  void _initNewSecret(int id, int stage, {int amount = 0}) {
    final s = getSecretById(id);
    final sp = s.progressComponent[stage];
    if (sp["volatile"]) {
      currentVolatileSecrets[id] = CurrentVolatileSecret(
        sid: id,
        stage: stage,
        progress: amount,
        total: sp["total"],
        totalStages: s.progressComponent.length,
      );
    } else {
      print("currentSecretPut");
      currentSecrets.put(
          id,
          CurrentSecretV2(
            sid: id,
            stage: stage,
            progress: amount,
            total: sp["total"],
            totalStages: s.progressComponent.length,
          ));
    }
  }

  void _completeSecret(int id) {
    //TODO: better side effects
    final s = getSecretById(id);
    completedSecrets.add(id);
    player.put("completedSecrets", completedSecrets);
    MyToast.showSecretToast(fToast, "Secret Unlocked! ${s.title}");
    addAlert(1);
    updateSecretsMultiplier();
  }

  void resetSecretProgression(int id) {
    currentSecrets.delete(id);
  }
}

class Secret {
  final int id; //cannot be changed once initialized, or else will have problems during updates
  final String exid; //can be changed to suit context later
  final List<int> prerequisites;
  final int theme;
  final String title;
  final String description;
  final double reward;
  final List<Map> progressComponent;
  final String type;

  Secret({
    required this.id,
    required this.exid,
    required this.title,
    required this.prerequisites,
    required this.theme,
    required this.description,
    required this.reward,
    required this.progressComponent,
    this.type = "normal",
  });
}
