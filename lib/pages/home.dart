import 'package:flutter/material.dart';
import 'package:ordinary_idle/partials/1cookie/CookieBackground.dart';
import 'package:ordinary_idle/partials/ShopComponent.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Secrets.dart';

class Home extends StatelessWidget {
  final Money pMoney;
  final Secrets pSecrets;

  Home(this.pSecrets, this.pMoney, {Key? key}) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Expanded(child: CookieBackground(pSecrets, pMoney.addCoins)),
          Container(height: 70, child: ShopComponent(pMoney)),
        ],
      ),
    );
  }
}
