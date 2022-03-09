import 'package:flutter/material.dart';

class Secrets extends StatelessWidget {
  const Secrets({Key? key}) : super(key: key);
  
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Index 2: Secrets',
      style: optionStyle,
    );
  }
}