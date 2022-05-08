// playerT1 model
// all things here will be reset after prestige

import 'package:hive_flutter/hive_flutter.dart';

mixin PlayerT1 {
  static const boxString = "playerT1";

  static Box getBox() {
    return Hive.box(boxString);
  }

  static double coins() {
    return getBox().get("coins", defaultValue: 0.0);
  }

  static void updateCoins(double coins) {
    getBox().put("coins", coins);
  }

  static List<int> hotbarShop() {
    return getBox().get("hotbarShop", defaultValue: <int>[0, 1]);
  }

  static void updateHotbarShop(List<int> hotbarShop) {
    getBox().put("hotbarShop", hotbarShop);
  }

  static double mMax() {
    return getBox().get("mMax", defaultValue: 0.0);
  }

  static void updateMMax(double mMax) {
    getBox().put("mMax", mMax);
  }
}
