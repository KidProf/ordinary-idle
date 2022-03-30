import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/data/Shops.dart';

class Player with Money, Shops {
  Player() {
    initShops();
    initMoney();
    // initSecrets();
  }
}
