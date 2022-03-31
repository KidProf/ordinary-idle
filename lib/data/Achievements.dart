import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV2.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:tuple/tuple.dart';

mixin Achievements {
  //INTERFACE
  //nth
  
  late FToast fToast;

  final Box player = Hive.box("player");
  final Box currentSecrets = Hive.box("currentSecretsV2");
  late Map<int,int> achievementsLevel =
      player.get("achievementsLevel", defaultValue: <int, int>{});
  late int trophies = player.get("trophies",defaultValue: 0);

  //ctor
  @protected
  void initAchievements(fToast) {
    this.fToast = fToast;
  }

  static final moneyChildren = [
    {
      "title": "Newbie",
      "threshold": 100,
      "reward": 1, //TODO: calibrate reward
    },
    {
      "title": "Scientific Notation",
      "threshold": 100000, //1e5
      "reward": 1,
    },
    {
      "title": "Prestige Unlocked",
      "threshold": 1000000, //1e6
      "reward": 1,
    },
    {
      "title": "Endgame",
      "threshold": 10000000000, //1e10
      "reward": 1,
    },
  ];

  static final tapChildren = [
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

  static final prestigeChildren = [
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
        return "Reach " + moneyChildren[i]["threshold"].toString() + " coins. Reward is " + moneyChildren[i]["reward"].toString() + " trophies";
      },
      children: moneyChildren,
    ),
    AchievementType(
      id: 2,
      exid: "tap",
      title: "Tap",
      descriptionI: (int i) {
        return "Tap " + tapChildren[i]["threshold"].toString() + " time. Reward is " + tapChildren[i]["reward"].toString() + " trophies";
      },
      children: tapChildren,
    ),
    AchievementType(
      id: 3,
      exid: "prestige",
      title: "Prestige",
      descriptionI: (int i) {
        return "Prestige " + prestigeChildren[i]["threshold"].toString() + " times. Reward is " + prestigeChildren[i]["reward"].toString() + " trophies";
      },
      children: prestigeChildren,
    ),
  ];

  static AchievementType getAchievementTypeById(int id) {
    return achievementTypes.where((a) => a.id == id).first;
  }

  static int getIdByExid(String exid) { //Money.dart interface
    return achievementTypes.where((a) => a.exid == exid).first.id;
  }

  int updateAchievementLevel(int id, num param) { //Money.dart interface
    int currentLevel = getAchievementLevel(id);
    final aType = getAchievementTypeById(id);
    while(aType.children.length > currentLevel+1 && param >= aType.children[currentLevel+1]["threshold"]){
      currentLevel++;
      print("Achievement unlocked with id: "+ id.toString() + ", level: "+ currentLevel.toString());
      achievementsLevel[id] = currentLevel;
      player.put("achievementsLevel",Map<int,int>.from(achievementsLevel));
      trophies += int.parse(aType.children[currentLevel]["reward"].toString());
      player.put("trophies",trophies);
      MyToast.showAchievementToast(fToast, "Secret Unlocked! ${aType.children[currentLevel]["title"]}");
    }
    return currentLevel;
  }

  int getAchievementLevel(int id){
    return achievementsLevel[id] ?? -1;
  }


}

class AchievementType {
  final int
      id; //cannot be changed once initialized, or else will have problems during updates
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
