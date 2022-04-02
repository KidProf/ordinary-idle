import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Player.dart';

class AchievementsPage extends StatelessWidget {
  final Player p;
  const AchievementsPage(this.p, {Key? key}) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Index 1: Achievements',
      style: optionStyle,
    );
  }
}