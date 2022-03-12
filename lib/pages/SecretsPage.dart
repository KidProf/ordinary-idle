import 'package:flutter/material.dart';
import 'package:ordinary_idle/util/Secrets.dart';

class SecretsPage extends StatelessWidget {
  final Secrets pSecrets;
  const SecretsPage(this.pSecrets, {Key? key}) : super(key: key);

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Index 2: Secrets',
      style: optionStyle,
    );
  }
}
