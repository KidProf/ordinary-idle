// playerT3 model:
// all things here will never be reset except when pressing the reset button

import 'package:hive_flutter/hive_flutter.dart';

mixin PlayerT3 {
  static Box getBox() {
    return Hive.box("playerT3");
  }

  static Map<dynamic, dynamic> achievementsLevel() {
    return getBox().get("achievementsLevel", defaultValue: <dynamic, dynamic>{});
  }

  static void updateAchievementsLevel(Map<dynamic, dynamic> achievementsLevel) {
    getBox().put("achievementsLevel", achievementsLevel);
  }

  static Map<dynamic, dynamic> achievementsParam() {
    return getBox().get("achievementsParam", defaultValue: <dynamic, dynamic>{});
  }

  static void updateAchievementsParam(Map<dynamic, dynamic> achievementsParam) {
    getBox().put("achievementsParam", achievementsParam);
  }

  static Map<dynamic, dynamic> achievementsParamMax() {
    return getBox().get("achievementsParamMax", defaultValue: <dynamic, dynamic>{});
  }

  static void updateAchievementsParamMax(Map<dynamic, dynamic> achievementsParamMax) {
    getBox().put("achievementsParamMax", achievementsParamMax);
  }

  static double otherMultiplier() {
    return getBox().get("otherMultiplierV2", defaultValue: 1.0);
  }

  static void updateOtherMultiplier(double otherMultiplier) {
    getBox().put("otherMultiplierV2", otherMultiplier);
  }

  static int trophies() {
    return getBox().get("trophies", defaultValue: 0);
  }

  static void updateTrophies(int trophies) {
    getBox().put("trophies", trophies);
  }
}
