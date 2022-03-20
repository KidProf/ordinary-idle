import 'package:flutter/material.dart';
import 'package:ordinary_idle/partials/1cookie/CookieBackground.dart';
import 'package:ordinary_idle/partials/2tapcount/TapCountBackground.dart';
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
    var currentBackground;
    switch(pMoney.getCurrentTheme()){
      case 1:
        currentBackground = CookieBackground(pSecrets, pMoney.tap);
        break;
      case 2:
        currentBackground = TapCountBackground(pSecrets, pMoney.tap);
    }
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Expanded(child: currentBackground),
          Container(height: 70, child: ShopComponent(pMoney)),
        ],
      ),
    );
  }
}
