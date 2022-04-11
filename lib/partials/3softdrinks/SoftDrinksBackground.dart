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

import 'package:shake/shake.dart';

class SoftDrinksBackground extends StatefulWidget {
  final Player p;

  SoftDrinksBackground(this.p, {Key? key}) : super(key: key);

  @override
  State<SoftDrinksBackground> createState() => _SoftDrinksBackgroundState();
}

class _SoftDrinksBackgroundState extends State<SoftDrinksBackground> implements Background {
  Timer? longPressTimer;
  Timer? shakeAnimationTimer;
  int timeSinceLastShake = 0;
  int timeSinceAnimationStart = 0;
  double hue = 0;
  String softDrink = "none";
  late ShakeDetector shakeDetector;

  @override
  void initState() {
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {
    print("SHAKE");
    timeSinceLastShake = 0;
    if (shakeAnimationTimer == null || shakeAnimationTimer?.isActive == false) {
      shakeAnimationTimer = Timer.periodic(const Duration(milliseconds: 33), (Timer t) {
        setState(() {
          timeSinceLastShake += 1;
          timeSinceAnimationStart += 1;
        });
        if (timeSinceLastShake >= 60) {
          timeSinceAnimationStart = 0;
          t.cancel();
        }
      });
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   _checkSecrets(context);
    // });

    return GestureDetector(
      onTapDown: onBackgroundTapDown,
      onLongPress: onLongPress,
      onLongPressUp: onLongPressUp,
      child: ChangeColors(
        hue: hue,
        brightness: getBrightness(hue),
        child: Container(
            color: Colors.Colors.red[900], //the color is necessary or else taps outside the cookie cannot be registered
            child: Container(
              alignment: Alignment.center,
              child: Transform.rotate(
                  angle: _calculateAngle(timeSinceAnimationStart),
                  child: softDrink == "none"
                      ? Image(
                          width: 100,
                          image: AssetImage('assets/images/softDrinks/' + softDrink + '.png'),
                        )
                      : ChangeColors(
                          hue: -hue,
                          brightness: -getBrightness(hue),
                          child: Image(
                            width: 100,
                            image: AssetImage('assets/images/softDrinks/' + softDrink + '.png'),
                          ),
                        )),
            )),
      ),
    );
  }

  @override
  void onBackgroundTapDown(TapDownDetails details) {
    widget.p.tap(1.0);
  }

  void _checkSecrets(BuildContext context) {}

  void onLongPress() {
    print("onLongPress");
    widget.p.progressSecret(11, 0);
    setState(() {
      softDrink = "none";
    });
    longPressTimer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      setState(() {
        hue += 0.01;
      });
    });
  }

  double getBrightness(double hue) {
    //increase the brightness at orange to make it more like fanta
    var h = hue % 2;
    if (0 <= h && h < 0.15) {
      return 0.2 - 0.2 * (h - 0.15).abs() / 0.15; //an increase slope h=0 to 0.15 and brightness=0.2
    } else if (0.15 <= h && h < 0.40) {
      return 0.2 - 0.2 * (h - 0.15).abs() / 0.25; //an decrease slope h=0.15 to 0.40
    } else {
      return 0;
    }
  }

  String getSoftDrink(double hue) {
    var h = hue % 2;
    if (hue >= 0.08 && (1.90 <= h || 0 <= h && h < 0.08)) {
      //does not allow cola to be discovered first cycle
      return "cola";
    } else if (0.08 <= h && h < 0.23) {
      return "fanta";
    } else if (0.60 <= h && h < 0.85) {
      return "sprite";
    } else if (1.05 <= h && h < 1.25) {
      return "pepsi";
    } else if (1.35 <= h && h < 1.50) {
      return "grape";
    } else {
      return "none";
    }
  }

  void onLongPressUp() {
    longPressTimer?.cancel();
    var softDrink = getSoftDrink(hue);
    if (softDrink == "fanta") {
      widget.p.progressSecret(12, 0);
    }
    if (softDrink == "pepsi") {
      widget.p.progressSecret(13, 0);
    }

    setState(() {
      this.softDrink = softDrink;
    });
    print("onLongPressUp, hue: " + (hue % 2).toString() + ", softDrink: " + softDrink);
  }

  @override
  void dispose() {
    longPressTimer?.cancel();
    shakeAnimationTimer?.cancel();
    super.dispose();
  }

  double _calculateAngle(int timeSinceAnimationStart) {
    double t = timeSinceAnimationStart%16;
    print(timeSinceAnimationStart.toString());
    if(t<=4){
      return 0.15*t;
    }else if(t<=12){
      return 0.75-(t-4)*0.15;
    }else{
      return 0.15*(t-16);
    }
  }
}
