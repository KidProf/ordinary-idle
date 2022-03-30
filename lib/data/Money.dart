import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/data/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

mixin Money {
  //INTERFACE
  double computeCoinsPerSecond();
  double computeCoinsPerTap();
  double getCostByShopId(int id, {int? level});

  //TODO: add functionality to store the log of the value
  late ValueNotifier<Map<String, dynamic>> vitals;
  late Box player;
  late double secretsMultiplier;
  late double otherMultiplier;
  final hotbarShopLimit = 3;

  //ctor
  @protected
  void initMoney() {
    player = Hive.box("player");
    otherMultiplier = player.get("otherMultiplier", defaultValue: 0.0);
    secretsMultiplier = _computeSecretsMultiplier();
    vitals = ValueNotifier<Map<String, dynamic>>({
      "coins": player.get("coins", defaultValue: 1.0),
      "multiplier": _computeMultiplier(),
      "coinsPerSecond": computeCoinsPerSecond(), //from shops: need call initShops first
      "coinsPerTap": computeCoinsPerTap(), //from shops: need call initShops first
      "hotbarShop": player.get("hotbarShop", defaultValue: <int>[0, 1]),
    });
  }

  void addIdleCoins() {
    addCoins(vitals.value["coinsPerSecond"]);
  }

  static String vitalsRepresentation(Map<String, dynamic> vitals) {
    return Util.doubleRepresentation(vitals["coins"]);
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
    return vitals.value["coins"];
  }

  double addCoins(double coins) {
    addCoinsWithoutMultiplier(coins * vitals.value["multiplier"]);
    return vitals.value["coins"];
  }

  // double addMultiplier(double multiplier) {
  //   vitals.value = {...vitals.value, "multiplier" : vitals.value["multiplier"]+multiplier};
  //   player.put("multiplier", vitals.value["multiplier"]);
  //   return vitals.value["multiplier"];
  // }

  double addCoinsWithoutMultiplier(double coins) {
    vitals.value = {...vitals.value, "coins": vitals.value["coins"] + coins};
    double netWorth = player.get("netWorth", defaultValue: 1.0);
    netWorth += coins;
    player.put("coins", vitals.value["coins"]);
    player.put("netWorth", netWorth);
    // print("VITALS COINS: "+vitals.value["coins"].toString()+" HIVE COINS: " + player.get("coins").toString());
    return vitals.value["coins"];
  }

  @override //Shops.dart interface
  bool subtractCoins(double coins) {
    if (vitals.value["coins"] - coins < 0) return false;
    vitals.value = {...vitals.value, "coins": vitals.value["coins"] - coins};
    player.put("coins", vitals.value["coins"]);
    return true;
  }

  void setCoins(double coins) {
    vitals.value = {...vitals.value, "coins": coins};
    player.put("coins", vitals.value["coins"]);
    return;
  }

  // void setMultiplier(double multiplier) {
  //   vitals.value = {...vitals.value, "multiplier" : multiplier};
  //   player.put("multiplier", vitals.value["multiplier"]);
  //   return;
  // }

  //recompute and update secretsMultiplier and hence multiplier, return new secretsMultiplier
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
    double sum = 0;
    final completedSecrets = player.get("completedSecrets", defaultValue: <int>[]);
    completedSecrets.forEach((id) {
      var s = Secrets.getSecretById(id);
      sum += s.reward;
    });
    return sum;
  }

  double _computeMultiplier() {
    return secretsMultiplier + otherMultiplier + 1;
  }

  @override //Shops.dart interface
  double updateCoinsPerTap() {
    var coinsPerTap = computeCoinsPerTap();
    print("coins per tap is: " + coinsPerTap.toString());
    vitals.value = {...vitals.value, "coinsPerTap": coinsPerTap};
    return coinsPerTap;
  }

  @override //Shops.dart interface
  double updateCoinsPerSecond() {
    var coinsPerSecond = computeCoinsPerSecond();
    print("coins per second is: " + coinsPerSecond.toString());
    vitals.value = {...vitals.value, "coinsPerSecond": coinsPerSecond};
    return coinsPerSecond;
  }

  @override //Shops.dart interface
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
        player.put("hotbarShop", newHotbar);
      } else {
        Fluttertoast.showToast(msg: "You can have at most " + hotbarShopLimit.toString() + " items in the hotbar");
      }
    } else if (value == false && vitals.value["hotbarShop"].contains(id)) {
      //remove
      print(vitals.value["hotbarShop"]);
      if (vitals.value["hotbarShop"].length > 1) {
        var newHotbar = vitals.value["hotbarShop"].where((int x) => x != id).toList();
        vitals.value = {...vitals.value, "hotbarShop": newHotbar};
        player.put("hotbarShop", newHotbar);
      } else {
        Fluttertoast.showToast(msg: "You need at least 1 item in the hotbar");
      }
    }
  }

  int getCurrentTheme() {
    return player.get("currentTheme", defaultValue: 1);
  }

  double getNetWorth() {
    return player.get("netWorth", defaultValue: 1.0);
  }
}
