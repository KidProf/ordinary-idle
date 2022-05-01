// playerT3 model:
// all things here will never be reset except when pressing the reset button
// double netWorth = 1.0
// double otherMultiplier = 1.0
// int trophies = 0

import 'package:hive_flutter/hive_flutter.dart';

mixin PlayerT1 {
  static Box getBox() {
    return Hive.box("player");
  }

  static Map<dynamic, dynamic> achievementsLevel() {
    return getBox().get("achievementsLevel", defaultValue: <dynamic, dynamic>{});
  }

  static void updateAchievementslevel(Map<dynamic, dynamic> achievementsLevel) {
    getBox().put("achievementsLevel", achievementsLevel);
  }

  static Map<dynamic, dynamic> achievementsParam() {
    return getBox().get("achievementsParam", defaultValue: <dynamic, dynamic>{});
  }

  static void updateAchievementsparam(Map<dynamic, dynamic> achievementsParam) {
    getBox().put("achievementsParam", achievementsParam);
  }

  static Map<dynamic, dynamic> achievementsParamMax() {
    return getBox().get("achievementsParamMax", defaultValue: <dynamic, dynamic>{});
  }

  static void updateAchievementsparammax(Map<dynamic, dynamic> achievementsParamMax) {
    getBox().put("achievementsParamMax", achievementsParamMax);
  }

  static double otherMultiplier() {
    return getBox().get("otherMultiplier", defaultValue: 1.0);
  }

  static void updateOthermultiplier(double otherMultiplier) {
    getBox().put("otherMultiplier", otherMultiplier);
  }

  static int trophies() {
    return getBox().get("trophies", defaultValue: 0);
  }

  static void updateTrophies(int trophies) {
    getBox().put("trophies", trophies);
  }
}
