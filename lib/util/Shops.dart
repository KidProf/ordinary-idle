import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV1.dart';
import 'package:ordinary_idle/model/PurchaseV1.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:tuple/tuple.dart';

abstract class Shops {
  //INTERFACE
  void updateCoinsPerTap();
  bool subtractCoins(double x);

  late Box purchases;
  late List<Shop> shops;
  Map<int, CurrentVolatileSecret> currentVolatileSecrets = {};

  static double _gain0(int i) => pow(1.2, i).toDouble();
  static double _cost0(int i) => (20 * pow(1.3, i)).toDouble();

  @mustCallSuper
  Shops() {
    purchases = Hive.box("purchases");
    shops = [
      Shop(
        id: 0,
        exid: "0",
        prerequisites: <Map<String, dynamic>>[],
        title: "Tap",
        description: "Increase coins per tap",
        descriptionI: (int i) => "Increase coins per tap to ${_gain0(i)}",
        type: "tap",
        gain: Resource(
          type: "tap",
          value: _gain0,
          callback: (int i) {
            updateCoinsPerTap();

            return true;
          },
        ),
        cost: Resource(
          type: "money",
          value: _cost0,
          callback: (int i) {
            return subtractCoins(_cost0(i));
          },
        ),
      ),
    ];
  }

  Shop getShopById(int id) {
    return shops.where((s) => s.id == id).first;
  }

  int getLevelById(int id) {
    return purchases.get(id) ?? 0;
  }

  bool purchaseItem(int id) {
    var s = getShopById(id);
    var level = getLevelById(id);
    print("cost of purchase: " + s.cost.value!(level).toString());
    var possible = s.cost.callback(level);

    if (!possible) return false;
    level += 1;
    s.gain.callback(level);
    purchases.put(id, level);
    return true;
  }

  @protected
  double computeCoinsPerTap() {
    return shops.where((s) => s.type == "tap").fold(0, (xs, x) => xs + x.gain.value!(getLevelById(x.id)));
  }

  double getCostById(int id, {int? level}) {
    var s = getShopById(id);
    var level1 = level ?? getLevelById(id);
    return s.cost.value!(level1);
  }

  double getGainById(int id, {int? level}) {
    var s = getShopById(id);
    var level1 = level ?? getLevelById(id);
    return s.gain.value!(level1);
  }

  String getDescriptionById(int id, {int? level}) {
    var s = getShopById(id);
    var level1 = level ?? getLevelById(id);
    return s.descriptionI(level1);
  }
}

class Shop {
  final int id; //cannot be changed once initialized, or else will have problems during updates
  final String exid; //can be changed to suit context later
  final List<Map<String, dynamic>>
      prerequisites; //maybe a list of ids and levels/ specific achievements/ specific achievements purchase?
  final String title;
  final String description;
  final String Function(int) descriptionI;
  final String
      type; //"tap","idle","achievements",..., this may not be necessary because class Resource already has a type
  final Resource gain;
  final Resource cost;

  Shop({
    required this.id,
    required this.exid,
    required this.title,
    required this.prerequisites,
    required this.description,
    required this.descriptionI,
    required this.type,
    required this.gain,
    required this.cost,
  });
}

class Resource {
  final String type; //"coins","tap","idle",...
  final double Function(int)? value;
  //GAIN: a closed form function that returns the coins per tap/ coins per second depends on type at level i
  //COST: a closed form functon that returns the cost to upgrade from level i to level i+1
  final bool Function(int) callback;
  //executes the purcahse, the return value of cost function is whether prerequisites are satisfied, the return value of gain functions should be always true

  Resource({required this.type, this.value, required this.callback});
}
