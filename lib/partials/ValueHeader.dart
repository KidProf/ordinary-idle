import 'package:flutter/material.dart';

class ValueHeader extends StatelessWidget {
  final double pCoins;

  const ValueHeader({required this.pCoins, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Image(image: AssetImage('assets/images/coin.png'), width: 30, height: 30),
      const SizedBox(width: 10),
      Text(pCoins.toString()),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }
}
