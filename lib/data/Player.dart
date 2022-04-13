import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:ordinary_idle/data/Achievements.dart';
import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/data/Shops.dart';

class Player with Money, Shops, Secrets, Achievements {
  final FToast fToast;
  final Function addAlert;

  Player(this.fToast, this.addAlert) {
    initShops();
    initMoney();
    initSecrets(fToast, addAlert);
    initAchievements(fToast, addAlert);
  }
}
