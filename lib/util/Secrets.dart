import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV1.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:tuple/tuple.dart';

class Secrets {
  late Box player;
  late Box currentSecrets;
  late List<int> completedSecrets;
  late List<int> unlockedThemes;
  late Function updateSecretsMultiplier;
  late FToast fToast;
  Map<int, CurrentVolatileSecret> currentVolatileSecrets = {};

  Secrets(this.updateSecretsMultiplier, this.fToast) {
    player = Hive.box("player");
    currentSecrets = Hive.box("currentSecrets");
    completedSecrets = player.get("completedSecrets", defaultValue: <int>[]);
    unlockedThemes = player.get("unlockedThemes", defaultValue: <int>[1]);
  }

  //TODO: Gen from CSV
  static final secrets = [
    //referenced in:
    //main.dart: check if it is completed before opening secrets page
    Secret(
        id: 1,
        exid: "0.1",
        prerequisites: [],
        title: "Welcome",
        description:
            "Tapping the secret button 15 times.\n\nCongratulations on discovering your first secret. I would say this is the most important secret, as it unlocks the secrets page and your ability to find other secrets.",
        theme: 0,
        reward: 1.0,
        progressComponent: [
          {
            "total": 15,
            "volatile": true,
          },
        ]),

    //referenced in:
    // CookieBackground.dart, check if it taps outside the cookie
    Secret(
      id: 2,
      exid: "1.1",
      prerequisites: [1],
      title: "More space to tap",
      description:
          "Tapping outside the cookie but inside the canvas 10 times.\n\nAs the cookie will move around and even change in size, I think making taps outside the cookie count is a good idea.",
      theme: 1,
      reward: 0.5,
      progressComponent: [
        {
          "total": 10,
          "volatile": false,
        },
      ],
    ),

    Secret(
      id: 3,
      exid: "1.2",
      prerequisites: [1],
      title: "Where did it go?",
      description: "Swipe the cookie up until it disappears from the screen.",
      theme: 1,
      reward: 1.0,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
    Secret(
      id: 4,
      exid: "1.3",
      prerequisites: [1, 3],
      title: "Diode",
      description: "Rotate the cookie anticlockwise for 4 cycles.",
      theme: 1,
      reward: 1.0,
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
          "total": double.infinity, //never completed
          "volatile": false,
        },
      ],
    ),
    Secret(
      id: 5,
      exid: "2.1",
      prerequisites: [1],
      title: "96966696966969699999666",
      description: "Invert the phone when the tap count only contains 6s and 9s.",
      theme: 2,
      reward: 1.0,
      progressComponent: [
        {
          "total": 1,
          "volatile": true,
        },
      ],
    ),
  ];

  static Secret getSecretById(int id) {
    return secrets.where((s) => s.id == id).first;
  }

  bool secretDoable(int id) {
    return prerequisiteMet(id) && !secretCompleted(id);
  }

  bool secretCompleted(int id) {
    return completedSecrets.contains(id);
  }

  bool prerequisiteMet(int id) {
    final s = getSecretById(id);

    // print(unlockedThemes);
    //if theme is 0, can be accessed anywhere
    if (s.theme != 0 && !unlockedThemes.contains(s.theme)) return false;

    for (var prerequisite in s.prerequisites) {
      if (!secretCompleted(prerequisite)) return false;
    }
    return true;
  }

  Tuple2<bool, int> secretProgress(int id) {
    if (currentSecrets.containsKey(id)) {
      final CurrentSecretV1 c = currentSecrets.get(id);
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

  void progressSecret(int id, int stage, {int amount = 1}) {
    print("entered progressSecret function with id: " + id.toString() + ", stage: " + stage.toString());
    if (secretCompleted(id) || !prerequisiteMet(id)) {
      return; //completed already, so no need tracking OR prerequisite not met, cannot start
    } else if (currentSecrets.containsKey(id)) {
      final CurrentSecretV1 c = currentSecrets.get(id);
      if (c.stage == stage) {
        //no progression if wrong stage, the ! is for null checking, which I think doesnt needed because we are sure it contains the key
        c.progress += amount;
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
        cv.progress += amount;
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
        _initNewSecret(id, 0, amount: amount);
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
          CurrentSecretV1(
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
    updateSecretsMultiplier();
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
