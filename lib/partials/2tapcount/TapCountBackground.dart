import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/util/Background.dart';
import 'package:ordinary_idle/util/Secrets.dart';

class TapCountBackground extends StatelessWidget  implements Background{
  final Secrets pSecrets;
  final Function(double) tap;
  const TapCountBackground(this.pSecrets, this.tap,{ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('currentSecrets').listenable(keys: [9999]), //listen to hidden secret only
        builder: (context, box, _) {
        var taps = pSecrets.secretProgress(9999).item2;
        var size = calcTextSize(taps.toString(), TextStyle(fontSize: 120, fontWeight: FontWeight.bold));
        print(size);
        return GestureDetector(
          onTapDown: onBackgroundTapDown,
          child: Container(
            color: Colors.green[100],
            alignment: Alignment.center,
            child: Text(taps.toString(),style: TextStyle(fontSize: 120, fontWeight: FontWeight.bold),)
          ),
        );
      }
    );
  }

  @override
  void onBackgroundTapDown(TapDownDetails details) {
    pSecrets.progressSecret(9999,0);
    tap(1.0);
  }

  Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }
}