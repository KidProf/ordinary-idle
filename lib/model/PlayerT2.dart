// playerT2 model:
// all things here will be reset after a second layer of prestige
// double prestigeMultipluer = 1.0;
// List<int> completedSecrets = [];
// int currentTheme = 1;
// List<int> visitedThemes = [1];

import 'package:hive_flutter/hive_flutter.dart';

mixin PlayerT2 {
  static Box getBox() {
    return Hive.box("playerT2");
  }

  static double prevMMax() {
    return getBox().get("prevMMax", defaultValue: 0.0);
  }

  static void updatePrevmmax(double prevMMax) {
    getBox().put("prevMMax", prevMMax);
  }

  static List<int> completedSecrets() {
    return getBox().get("completedSecrets", defaultValue: <int>[]);
  }

  static void updateCompletedsecrets(List<int> completedSecrets) {
    getBox().put("completedSecrets", completedSecrets);
  }

  static int currentTheme() {
    return getBox().get("currentTheme", defaultValue: 1);
  }

  static void updateCurrenttheme(int currentTheme) {
    getBox().put("currentTheme", currentTheme);
  }

  static List<int> visitedThemes() {
    return getBox().get("visitedThemes", defaultValue: [1]);
  }

  static void updateVisitedthemes(List<int> visitedThemes) {
    getBox().put("visitedThemes", visitedThemes);
  }

  static double prestigeMultiplier() {
    return getBox().get("prestigeMultiplier", defaultValue: 1.0);
  }

  static void updatePrestigemultiplier(double prestigeMultiplier) {
    getBox().put("prestigeMultiplier", prestigeMultiplier);
  }
}
