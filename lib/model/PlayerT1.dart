// player model: (note the box name is still player)
// all things here will be reset after prestige

import 'package:hive_flutter/hive_flutter.dart';

mixin PlayerT1 {
  static Box getBox() {
    return Hive.box("player");
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

  static void updateHotbarshop(List<int> hotbarShop) {
    getBox().put("hotbarShop", hotbarShop);
  }

  static double mMax() {
    return getBox().get("mMax", defaultValue: 0.0);
  }

  static void updateMmax(double mMax) {
    getBox().put("mMax", mMax);
  }
}
