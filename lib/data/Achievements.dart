import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV2.dart';
import 'package:ordinary_idle/model/PlayerT3.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:tuple/tuple.dart';

mixin Achievements {
  //INTERFACE
  addTrophies(int t);

  late FToast fToast;
  late Function addAlert;

  final Box currentSecrets = Hive.box("currentSecretsV2");
  late Map<dynamic, dynamic> achievementsLevel = PlayerT3
      .achievementsLevel(); //should be Map<int,int> but Hive can only store it in the form of <dynamic, dynamic>
  late Map<dynamic, dynamic> achievementsParam = PlayerT3.achievementsParam();
  late Map<dynamic, dynamic> achievementsParamMax = PlayerT3.achievementsParamMax();
  //ctor
  @protected
  void initAchievements(fToast, addAlert) {
    this.fToast = fToast;
    this.addAlert = addAlert;
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
    // {
    //   "title": "Change Theme Unlocked", //TEMP
    //   "threshold": 1000000.0, //1e6
    //   "reward": 1,
    // },
    {
      "title": "Prestige Unlocked",
      "threshold": 10000000.0, //1e7
      "reward": 1,
    },
    {
      "title": "Eonomic Boom",
      "threshold": 1000000000000.0, //1e12
      "reward": 1,
    },
    {
      "title": "Endgame",
      "threshold": 1000000000000000000.0, //1e18
      "reward": 1,
    },
  ];

  static final _tapChildren = [
    {
      "title": "Tapping Amateur",
      "threshold": 100,
      "reward": 1,
    },
    {
      "title": "Broken Screen",
      "threshold": 2000,
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
    {
      "title": "Enjoyment of resetting",
      "threshold": 5,
      "reward": 1,
    },
  ];

  static final _buyChildren = [
    {
      "title": "Small spender",
      "threshold": 20,
      "reward": 1,
    },
    {
      "title": "Big spender",
      "threshold": 100,
      "reward": 1,
    },
    {
      "title": "Huge spender",
      "threshold": 300,
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
            Functions.doubleRepresentation(_moneyChildren[i]["threshold"]! as double) +
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
            (_tapChildren[i]["threshold"] == 1 ? " time." : " times.") +
            " The reward is " +
            _tapChildren[i]["reward"].toString() +
            (_tapChildren[i]["reward"] == 1 ? " trophy." : " trophies.");
      },
      children: _tapChildren,
    ),
    AchievementType(
      id: 5,
      exid: "prestige",
      title: "Prestige",
      descriptionI: (int i) {
        return "Prestige " +
            _prestigeChildren[i]["threshold"].toString() +
            (_prestigeChildren[i]["threshold"] == 1 ? " time." : " times.") +
            " The reward is " +
            _prestigeChildren[i]["reward"].toString() +
            (_prestigeChildren[i]["reward"] == 1 ? " trophy." : " trophies.");
      },
      children: _prestigeChildren,
    ),
    AchievementType(
      id: 4,
      exid: "buy",
      title: "Upgrades Purchased",
      descriptionI: (int i) {
        return "Purchase " +
            _buyChildren[i]["threshold"].toString() +
            (_buyChildren[i]["threshold"] == 1 ? " upgrade." : " upgrades.") +
            " The reward is " +
            _buyChildren[i]["reward"].toString() +
            (_buyChildren[i]["reward"] == 1 ? " trophy." : " trophies.");
      },
      children: _buyChildren,
    ),
    //next id = 6
  ];

  static AchievementType getAchievementTypeById(int id) {
    return achievementTypes.where((a) => a.id == id).first;
  }

  static AchievementType getAchievementTypeByExid(String exid) {
    return achievementTypes.where((a) => a.exid == exid).first;
  }

  static int getIdByExid(String exid) {
    //Money.dart interface
    return achievementTypes.where((a) => a.exid == exid).first.id;
  }

  static String getExidById(int id) {
    //Money.dart interface
    return achievementTypes.where((a) => a.id == id).first.exid;
  }

  int updateAchievementParam(String exid, num param) {
    //Money.dart interface
    final id = getIdByExid(exid);
    achievementsParam[id] = param;
    PlayerT3.updateAchievementsParam(achievementsParam);

    if (achievementsParamMax[id] == null || achievementsParam[id] > achievementsParamMax[id]) {
      achievementsParamMax[id] = achievementsParam[id];
      PlayerT3.updateAchievementsParamMax(achievementsParamMax);
    }

    int currentLevel = getAchievementLevel(exid);
    final aType = getAchievementTypeById(id);
    while (aType.children.length > currentLevel + 1 && param >= aType.children[currentLevel + 1]["threshold"]) {
      //LEVEL UP
      currentLevel++;
      print("Achievement unlocked with id: " + id.toString() + ", level: " + currentLevel.toString());
      achievementsLevel[id] = currentLevel;
      PlayerT3.updateAchievementsLevel(achievementsLevel);
      addTrophies(int.parse(aType.children[currentLevel]["reward"].toString()));
      MyToast.showAchievementToast(fToast, "Achievement Unlocked! ${aType.children[currentLevel]["title"]}");
      addAlert(2);
    }
    return currentLevel;
  }

  int incrementAchievementParam(String exid) {
    //Money.dart interface
    num newParam = getAchievementParam(exid) + 1;
    return updateAchievementParam(exid, newParam);
  }

  int getAchievementLevel(String exid) {
    return achievementsLevel[getIdByExid(exid)] ?? -1;
  }

  num getAchievementParam(String exid) {
    return achievementsParam[getIdByExid(exid)] ?? 0;
  }

  num getAchievementParamMax(String exid) {
    // print("local: $achievementsParamMax\n hive:${PlayerT3.achievementsParamMax()}");
    return achievementsParamMax[getIdByExid(exid)] ?? 0;
  }

  double getAchievementProgress(int id, int level) {
    final aType = getAchievementTypeById(id);
    return getAchievementParamMax(getExidById(id)) / aType.children[level]["threshold"];
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
