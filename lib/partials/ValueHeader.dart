import 'package:flutter/material.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Util.dart';

class ValueHeader extends StatelessWidget {
  final Map<String, dynamic> money;

  const ValueHeader(this.money, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Image(image: AssetImage('assets/images/coin.png'), width: 30, height: 30),
        const SizedBox(width: 10),
        Text(
          Money.moneyRepresentation(money),
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        const SizedBox(width: 50),
        Text(
          money["multiplier"].toString() + "x",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
