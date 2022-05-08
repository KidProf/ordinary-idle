// playerT2 model:
// all things here will be reset after a second layer of prestige

import 'package:hive_flutter/hive_flutter.dart';

mixin PlayerT2 {
  static Box getBox() {
    return Hive.box("playerT2");
  }

  static double prevMMax() {
    return getBox().get("prevMMax", defaultValue: 0.0);
  }

  static void updatePrevMMax(double prevMMax) {
    getBox().put("prevMMax", prevMMax);
  }

  static List<int> completedSecrets() {
    return getBox().get("completedSecrets", defaultValue: <int>[]);
  }

  static void updateCompletedSecrets(List<int> completedSecrets) {
    getBox().put("completedSecrets", completedSecrets);
  }

  static int currentTheme() {
    return getBox().get("currentTheme", defaultValue: 1);
  }

  static void updateCurrentTheme(int currentTheme) {
    getBox().put("currentTheme", currentTheme);
  }

  static List<int> visitedThemes() {
    return getBox().get("visitedThemes", defaultValue: [1]);
  }

  static void updateVisitedThemes(List<int> visitedThemes) {
    getBox().put("visitedThemes", visitedThemes);
  }

  static double prestigeMultiplier() {
    return getBox().get("prestigeMultiplier", defaultValue: 1.0);
  }

  static void updatePrestigeMultiplier(double prestigeMultiplier) {
    getBox().put("prestigeMultiplier", prestigeMultiplier);
  }
}
