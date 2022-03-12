import 'package:flutter/material.dart';
import 'package:flame/src/game/game_widget/game_widget.dart';

import 'package:ordinary_idle/partials/Cookie1.dart';

class Home extends StatelessWidget {
  final Function addCoins;
  late Cookie game;

  Home(this.addCoins, {Key? key}) {
    game = Cookie(addCoins);
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
    );
  }
}
