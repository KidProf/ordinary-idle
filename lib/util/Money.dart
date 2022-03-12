import 'package:flutter/material.dart';

class Money{
  late ValueNotifier<double> _coins;
  late double _expCoins;
  late bool _useExp;

  Money(coins, expCoins, useExp){
    _coins = ValueNotifier<double>(coins ?? 1.0);
    _expCoins = expCoins ?? 0.0;
    _useExp = useExp ?? false;
  }

  ValueNotifier<Map<String, Object>> get getMoney{
    return ValueNotifier({
      'useExp' : _useExp,
      'value' : _useExp ? _expCoins : _coins,
      'valueString' : _useExp ? _expCoins.toString() : _coins.toString(),
    });
  }
  ValueNotifier<double> get getCoins{
    return _coins;
  }

  double addCoins(double coins){
    if(!_useExp){
      _coins.value += coins;
    }
    return _coins.value;
  }

  void setCoins(double coins){
    if(!_useExp){
      _coins.value = coins;
    }
  }
}