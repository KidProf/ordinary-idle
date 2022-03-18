import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:ordinary_idle/util/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

class Money extends Shops { 
  //TODO: add functionality to store the log of the value

  late ValueNotifier<Map<String, dynamic>> money;
  late Box player;
  late double secretsMultiplier;
  late double otherMultiplier;
  late double coinsPerTap;

  Money() : super() {
    player = Hive.box("player");
    otherMultiplier = player.get("otherMultiplier", defaultValue: 0.0);
    secretsMultiplier = _computeSecretsMultiplier();
    coinsPerTap = computeCoinsPerTap();
    money = ValueNotifier<Map<String, dynamic>>({
      "coins": player.get("coins", defaultValue: 1.0),
      "multiplier": _computeMultiplier(),
    });
    
    // _expCoins = player.get("expCoins", defaultValue: 0.0);
    // _useExp = player.get("useExp", defaultValue: false);
  }

  static String moneyRepresentation(Map<String, dynamic> money){
    return Util.doubleRepresentation(money["coins"],2);
  }

  ValueNotifier<Map<String, dynamic>> get getMoneyListener {
    return money;
  }

  // ValueNotifier<double> get getCoinsListener {
  //   return _coins;
  // }

  double get getCoins {
    return money.value["coins"];
  }

  double get getMultiplier {
    return money.value["multiplier"];
  }

  double tap(double coins) {
    money.value = {...money.value, "coins": money.value["coins"] + coins * money.value["multiplier"] * coinsPerTap};
    player.put("coins", money.value["coins"]);
    return money.value["coins"];
  }

  double addCoins(double coins) {
    money.value = {...money.value, "coins": money.value["coins"] + coins * money.value["multiplier"]};
    player.put("coins", money.value["coins"]);
    return money.value["coins"];
  }

  // double addMultiplier(double multiplier) {
  //   money.value = {...money.value, "multiplier" : money.value["multiplier"]+multiplier};
  //   player.put("multiplier", money.value["multiplier"]);
  //   return money.value["multiplier"];
  // }

  double addCoinsWithoutMultiplier(double coins) {
    money.value = {...money.value, "coins": money.value["coins"] + coins};
    player.put("coins", money.value["coins"]);
    return money.value["coins"];
  }

  @override //Shops.dart interface
  bool subtractCoins(double coins) {
    if (money.value["coins"] - coins < 0) return false;
    money.value = {...money.value, "coins": money.value["coins"] - coins};
    player.put("coins", money.value["coins"]);
    return true;
  }

  void setCoins(double coins) {
    money.value = {...money.value, "coins": coins};
    player.put("coins", money.value["coins"]);
    return;
  }

  // void setMultiplier(double multiplier) {
  //   money.value = {...money.value, "multiplier" : multiplier};
  //   player.put("multiplier", money.value["multiplier"]);
  //   return;
  // }

  //recompute and update secretsMultiplier and hence multiplier, return new secretsMultiplier
  double updateSecretsMultiplier() {
    print("updateSecretsMultiplier");
    secretsMultiplier = _computeSecretsMultiplier();
    updateMultiplier();
    return secretsMultiplier;
  }

  double updateMultiplier() {
    var x = _computeMultiplier();
    money.value = {...money.value, "multiplier": x};
    print("updateMultiplier "+x.toString());
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
    coinsPerTap = computeCoinsPerTap();
    print("updateCoinsPerTap "+coinsPerTap.toString());
    return coinsPerTap;
  }

}
