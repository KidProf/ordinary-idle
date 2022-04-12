import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/partials/1softdrinks/SoftDrinksBackground.dart';
import 'package:ordinary_idle/partials/2tapcount/TapCountBackground.dart';
import 'package:ordinary_idle/partials/3cookie/CookieBackground.dart';
import 'package:ordinary_idle/partials/ShopComponent.dart';
import 'package:ordinary_idle/data/Secrets.dart';

class Home extends StatelessWidget {
  final Player p;

  Home(this.p, {Key? key}) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    var currentBackground;
    var backgroundColor;
    switch (p.getCurrentTheme()) {
      case 1:
        currentBackground = SoftDrinksBackground(p);
        backgroundColor = Colors.grey[300];
        break;
      case 2:
        currentBackground = TapCountBackground(p);
        backgroundColor = Colors.green[100];
        break;
      case 3:
        currentBackground = CookieBackground(p);
        backgroundColor = Colors.amber[100];
        break;
      default:
        currentBackground = CookieBackground(p);
        backgroundColor = Colors.amber[100];
        break;
    }
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(child: currentBackground),
            Container(height: 70, child: ShopComponent(p)),
          ],
        ),
      ),
    );
  }
}
