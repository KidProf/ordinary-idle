import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV2.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:ordinary_idle/util/Util.dart';
import 'package:tuple/tuple.dart';

mixin Achievements {
  //INTERFACE
  addTrophies(int t);

  late FToast fToast;

  final Box player = Hive.box("player");
  final Box currentSecrets = Hive.box("currentSecretsV2");
  late Map<dynamic, dynamic> achievementsLevel = player.get("achievementsLevel", defaultValue: <dynamic,
      dynamic>{}); //should be Map<int,int> but Hive can only store it in the form of <dynamic, dynamic>

  //ctor
  @protected
  void initAchievements(fToast) {
    this.fToast = fToast;
  }

  //the first one is level 0, if you have not unlocked the first one you will be in level -1
  static final _moneyChildren = [
    {
      "title": "Newbie",
      "threshold": 100.0, //must add .0 to make it into a double
      "reward": 1, //TODO: calibrate reward
    },
    {
      "title": "Scientific Notation",
      "threshold": 100000.0, //1e5
      "reward": 1,
    },
    {
      "title": "Prestige Unlocked",
      "threshold": 1000000.0, //1e6
      "reward": 1,
    },
    {
      "title": "Endgame",
      "threshold": 1000000000000.0, //1e12
      "reward": 1,
    },
  ];

  static final _tapChildren = [
    {
      "title": "Amateur",
      "threshold": 100,
      "reward": 1,
    },
    {
      "title": "Broken Screen",
      "threshold": 10000,
      "reward": 1,
    },
  ];

  static final _prestigeChildren = [
    {
      "title": "Reward for resetting",
      "threshold": 1,
      "reward": 1,
    },
    {
      "title": "Second Time",
      "threshold": 2,
      "reward": 1,
    },
  ];

  static final achievementTypes = [
    AchievementType(
      id: 1,
      exid: "money",
      title: "Money",
      descriptionI: (int i) {
        return "Reach " +
            Util.doubleRepresentation(_moneyChildren[i]["threshold"]! as double) +
            " coins. The reward is " +
            _moneyChildren[i]["reward"].toString() +
            (_moneyChildren[i]["reward"] == 1 ? " trophy." : " trophies.");
      },
      children: _moneyChildren,
    ),
    AchievementType(
      id: 2,
      exid: "tap",
      title: "Tap",
      descriptionI: (int i) {
        return "Tap " +
            _tapChildren[i]["threshold"].toString() +
            " time. The reward is " +
            _tapChildren[i]["reward"].toString() +
            (_tapChildren[i]["reward"] == 1 ? " trophy." : " trophies.");
      },
      children: _tapChildren,
    ),
    AchievementType(
      id: 3,
      exid: "prestige",
      title: "Prestige",
      descriptionI: (int i) {
        return "Prestige " +
            _prestigeChildren[i]["threshold"].toString() +
            " times. The reward is " +
            _prestigeChildren[i]["reward"].toString() +
            (_prestigeChildren[i]["reward"] == 1 ? " trophy." : " trophies.");
      },
      children: _prestigeChildren,
    ),
  ];

  static AchievementType getAchievementTypeById(int id) {
    return achievementTypes.where((a) => a.id == id).first;
  }

  static int getIdByExid(String exid) {
    //Money.dart interface
    return achievementTypes.where((a) => a.exid == exid).first.id;
  }

  int updateAchievementLevel(int id, num param) {
    //Money.dart interface
    int currentLevel = getAchievementLevel(id);
    final aType = getAchievementTypeById(id);
    while (aType.children.length > currentLevel + 1 && param >= aType.children[currentLevel + 1]["threshold"]) {
      currentLevel++;
      print("Achievement unlocked with id: " + id.toString() + ", level: " + currentLevel.toString());
      achievementsLevel[id] = currentLevel;
      player.put("achievementsLevel", achievementsLevel);
      addTrophies(int.parse(aType.children[currentLevel]["reward"].toString()));
      MyToast.showAchievementToast(fToast, "Secret Unlocked! ${aType.children[currentLevel]["title"]}");
    }
    return currentLevel;
  }

  int getAchievementLevel(int id) {
    return achievementsLevel[id] ?? -1;
  }
}

class AchievementType {
  final int id; //cannot be changed once initialized, or else will have problems during updates
  final String exid; //can be changed to suit context later
  // final List<int> prerequisites;
  final String title;
  // final String description; //overall description
  final String Function(int) descriptionI; //individual descriptions

  final List<Map<String, dynamic>> children;

  AchievementType({
    required this.id,
    required this.exid,
    required this.title,
    // required this.prerequisites,
    // required this.description,
    required this.descriptionI,
    required this.children,
  });
}
