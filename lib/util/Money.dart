import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Money {
  late Box player;
  late ValueNotifier<double> _coins;
  late double _expCoins;
  late bool _useExp;

  Money() {
    player = Hive.box("player");
    _coins = ValueNotifier<double>(player.get("coins", defaultValue: 1.0));
    _expCoins = player.get("expCoins", defaultValue: 0.0);
    _useExp = player.get("useExp", defaultValue: false);
  }

  ValueNotifier<Map<String, Object>> get getMoney {
    return ValueNotifier({
      'useExp': _useExp,
      'value': _useExp ? _expCoins : _coins,
      'valueString': _useExp ? _expCoins.toString() : _coins.toString(),
    });
  }

  ValueNotifier<double> get getCoinsListener {
    return _coins;
  }

  double get getCoins {
    return _coins.value;
  }

  double addCoins(double coins) {
    if (!_useExp) {
      _coins.value += coins;
    }
    player.put("coins", _coins.value);
    return _coins.value;
  }

  void setCoins(double coins) {
    if (!_useExp) {
      _coins.value = coins;
    }
    player.put("coins", _coins.value);
  }
}
