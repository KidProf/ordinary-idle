import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/data/Achievements.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/data/Shops.dart';
import 'package:ordinary_idle/model/PlayerT1.dart';
import 'package:ordinary_idle/model/PlayerT2.dart';
import 'package:ordinary_idle/model/PlayerT3.dart';
import 'package:ordinary_idle/util/Functions.dart';

mixin Money {
  //INTERFACE
  double computeCoinsPerSecond();
  double computeCoinsPerTap();
  double getCostByShopId(int id, {int? level});
  int updateAchievementParam(int id, num param);
  int incrementAchievementParam(int id);

  //TODO: add functionality to store the log of the value
  late ValueNotifier<Map<String, dynamic>> vitals;
  late double secretsMultiplier;
  late double prestigeMultiplier;
  late double otherMultiplier;
  final hotbarShopLimit = 3;

  //ctor
  @protected
  void initMoney() {
    otherMultiplier = PlayerT3.otherMultiplier();
    prestigeMultiplier = PlayerT2.prestigeMultiplier();

    secretsMultiplier = _computeSecretsMultiplier();

    vitals = ValueNotifier<Map<String, dynamic>>({
      "coins": PlayerT1.coins(),
      "multiplier": _computeMultiplier(),
      "coinsPerSecond": computeCoinsPerSecond(), //from shops: need call initShops first
      "coinsPerTap": computeCoinsPerTap(), //from shops: need call initShops first
      "hotbarShop": PlayerT1.hotbarShop(),
      "trophies": PlayerT3.trophies(),
    });
  }

  void addIdleCoins() {
    addCoins(vitals.value["coinsPerSecond"]);
  }

  static String vitalsRepresentation(Map<String, dynamic> vitals) {
    return Functions.doubleRepresentation(vitals["coins"]);
  }

  ValueNotifier<Map<String, dynamic>> get getVitalsListener {
    return vitals;
  }

  // ValueNotifier<double> get getCoinsListener {
  //   return _coins;
  // }

  double get getCoins {
    return vitals.value["coins"];
  }

  double get getMultiplier {
    return vitals.value["multiplier"];
  }

  double tap(double coins) {
    addCoins(vitals.value["coinsPerTap"] * coins);
    incrementAchievementParam(Achievements.getIdByExid("tap"));
    return vitals.value["coins"];
  }

  double addCoins(double coins) {
    addCoinsWithoutMultiplier(coins * vitals.value["multiplier"]);
    return vitals.value["coins"];
  }

  double addCoinsWithoutMultiplier(double coins) {
    vitals.value = {...vitals.value, "coins": vitals.value["coins"] + coins};
    PlayerT1.updateCoins(vitals.value["coins"]);

    if(vitals.value["coins"] > PlayerT1.mMax()){
      PlayerT1.updateMMax(vitals.value["coins"]);
    }
    
    updateAchievementParam(Achievements.getIdByExid("money"), vitals.value["coins"]);

    return vitals.value["coins"];
  }

  @override //Shops.dart interface
  bool subtractCoins(double coins) {
    if (vitals.value["coins"] - coins < 0) return false;
    vitals.value = {...vitals.value, "coins": vitals.value["coins"] - coins};
    PlayerT1.updateCoins(vitals.value["coins"]);
    return true;
  }

  void setCoins(double coins) {
    vitals.value = {...vitals.value, "coins": coins};
    PlayerT1.updateCoins(vitals.value["coins"]);
    return;
  }

  //recompute and update secretsMultiplier and hence multiplier, return new secretsMultiplier
  @protected //Secrets.dart interface
  double updateSecretsMultiplier() {
    secretsMultiplier = _computeSecretsMultiplier();
    updateMultiplier();
    return secretsMultiplier;
  }

  double updateMultiplier() {
    var x = _computeMultiplier();
    vitals.value = {...vitals.value, "multiplier": x};
    print("updateMultiplier " + x.toString());
    return x;
  }

  double _computeSecretsMultiplier() {
    double product = 1;
    final completedSecrets = PlayerT2.completedSecrets();
    completedSecrets.forEach((id) {
      var s = Secrets.getSecretById(id);
      product *= s.reward;
    });
    return product;
  }

  double _computeMultiplier() {
    return secretsMultiplier * prestigeMultiplier * otherMultiplier;
  }

  Map<String, double> getMulitpliers() {
    return <String, double>{
      "Secrets": secretsMultiplier,
      "Prestige": prestigeMultiplier,
      "Others": otherMultiplier,
    };
  }

  @protected //Shops.dart interface
  double updateCoinsPerTap() {
    var coinsPerTap = computeCoinsPerTap();
    print("coins per tap is: " + coinsPerTap.toString());
    vitals.value = {...vitals.value, "coinsPerTap": coinsPerTap};
    return coinsPerTap;
  }

  @protected //Shops.dart interface
  double updateCoinsPerSecond() {
    var coinsPerSecond = computeCoinsPerSecond();
    print("coins per second is: " + coinsPerSecond.toString());
    vitals.value = {...vitals.value, "coinsPerSecond": coinsPerSecond};
    return coinsPerSecond;
  }

  @protected //Shops.dart interface
  bool possibleByShopId(int id, {int? level}) {
    var cost = getCostByShopId(id, level: level);
    return cost <= vitals.value["coins"];
  }

  void setHotbarShop(int id, bool value) {
    if (value == true && !vitals.value["hotbarShop"].contains(id)) {
      //add
      if (vitals.value["hotbarShop"].length < hotbarShopLimit) {
        var newHotbar = <int>[...vitals.value["hotbarShop"], id];
        newHotbar.sort();
        vitals.value = {...vitals.value, "hotbarShop": newHotbar};
        PlayerT1.updateHotbarShop(newHotbar);
      } else {
        Fluttertoast.showToast(msg: "You can have at most " + hotbarShopLimit.toString() + " items in the hotbar");
      }
    } else if (value == false && vitals.value["hotbarShop"].contains(id)) {
      //remove
      print(vitals.value["hotbarShop"]);
      if (vitals.value["hotbarShop"].length > 1) {
        var newHotbar = vitals.value["hotbarShop"].where((int x) => x != id).toList();
        vitals.value = {...vitals.value, "hotbarShop": newHotbar};
        PlayerT1.updateHotbarShop(newHotbar);
      } else {
        Fluttertoast.showToast(msg: "You need at least 1 item in the hotbar");
      }
    }
  }

  int getCurrentTheme() {
    return PlayerT2.currentTheme();
  }

  void addTrophies(int t) {
    //Achievements.dart interface
    vitals.value = {...vitals.value, "trophies": vitals.value["trophies"] + t};
    PlayerT3.updateTrophies(vitals.value["trophies"]);
  }

  double getMMax() {
    return PlayerT1.mMax();
  }

  double getPrevMMax() {
    return PlayerT2.prevMMax();
  }

  double computePrestigeMultiplier() {
    final m = getMMax();
    return pow(10, (log(m) / log(10) - 4) * 1 / 6).toDouble();
  }
}
