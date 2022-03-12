import 'package:flutter/material.dart';
import 'package:flame/src/game/game_widget/game_widget.dart';

import 'package:ordinary_idle/partials/Cookie1.dart';
import 'package:ordinary_idle/util/Secrets.dart';

class Home extends StatelessWidget {
  final Function addCoins;
  final Secrets pSecrets;
  late Cookie game;

  Home(this.pSecrets, this.addCoins, {Key? key}) {
    game = Cookie(addCoins);
    // super(key: key); idk why it is bugged
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
    );
  }
}
