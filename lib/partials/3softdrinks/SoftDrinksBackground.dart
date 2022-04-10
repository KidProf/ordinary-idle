import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/util/Background.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:ordinary_idle/util/ChangeColors.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class SoftDrinksBackground extends StatefulWidget {
  final Player p;

  SoftDrinksBackground(this.p, {Key? key}) : super(key: key);

  @override
  State<SoftDrinksBackground> createState() => _SoftDrinksBackgroundState();
}

class _SoftDrinksBackgroundState extends State<SoftDrinksBackground>
    implements Background {
  late Timer? longPressTimer = null;
  double hue = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('currentSecretsV2')
            .listenable(keys: [9999]), //listen to secret 9999 only
        builder: (context, box, _) {
          // WidgetsBinding.instance?.addPostFrameCallback((_) {
          //   _checkSecrets(context);
          // });

          return GestureDetector(
            onTapDown: onBackgroundTapDown,
            onLongPress: onLongPress,
            onLongPressUp: onLongPressUp,
            child: ChangeColors(
              hue: hue,
              child: Container(
                color: Colors.Colors.red[
                    900], //the color is necessary or else taps outside the cookie cannot be registered
                child: Container(
                    alignment: Alignment.center,
                    child: const Image(
                      width: 100,
                      image: AssetImage('assets/images/softDrink.png'),
                    )),
              ),
            ),
          );
        });
  }

  @override
  void onBackgroundTapDown(TapDownDetails details) {
    widget.p.tap(1.0);
  }

  void _checkSecrets(BuildContext context) {}

  void onLongPress() {
    print("onLongPress");
    widget.p.progressSecret(11,0);

    longPressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        hue += 0.01;
      });
    });
  }

  void onLongPressUp() {
    print("onLongPressUp");
    longPressTimer?.cancel();
  }

  @override
  void dispose() {
    longPressTimer?.cancel();
    super.dispose();
  }
}
