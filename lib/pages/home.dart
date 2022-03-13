import 'package:flutter/material.dart';
// import 'package:ordinary_idle/partials/Cookie1.dart';
import 'package:ordinary_idle/util/Secrets.dart';

class Home extends StatelessWidget {
  final Function addCoins;
  final Secrets pSecrets;

  Home(this.pSecrets, this.addCoins, {Key? key}) : super(key: key) {
    // game = Cookie(addCoins);
    //  idk why it is bugged
  }

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Text("Home");
  }
}
