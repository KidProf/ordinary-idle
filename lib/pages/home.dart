import 'package:flutter/material.dart';
import 'package:flame/src/game/game_widget/game_widget.dart';

import '../partials/1cookie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }

}

class HomeState extends State<Home> {
  
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  
  final Cookie game = Cookie();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
        game: game,
    );
  }
}
