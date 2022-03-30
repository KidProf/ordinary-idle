import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Secrets.dart';

class Achievements extends StatelessWidget {
  final Secrets pSecrets;
  const Achievements(this.pSecrets, {Key? key}) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Index 1: Achievements',
      style: optionStyle,
    );
  }
}
