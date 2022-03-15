import 'package:flutter/material.dart';

class ValueHeader extends StatelessWidget {
  final double pCoins;
  final double pMultiplier;

  const ValueHeader({required this.pCoins, required this.pMultiplier, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Image(image: AssetImage('assets/images/coin.png'), width: 30, height: 30),
      const SizedBox(width: 10),
      Text(pCoins.toString(), style: TextStyle(fontSize: 25,)),
      const SizedBox(width: 50),
      Text(pMultiplier.toString()+"x", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,)),
      
    ], mainAxisAlignment: MainAxisAlignment.center,);
  }
}
