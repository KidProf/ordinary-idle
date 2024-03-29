import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/util/Background.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:ordinary_idle/util/ChangeColors.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:shake_event/shake_event.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math_64.dart';

// import 'package:shake/shake.dart';

class SoftDrinksBackground extends StatefulWidget {
  final Player p;

  SoftDrinksBackground(this.p, {Key? key}) : super(key: key);

  @override
  State<SoftDrinksBackground> createState() => _SoftDrinksBackgroundState();
}

class _SoftDrinksBackgroundState extends State<SoftDrinksBackground> with ShakeHandler implements Background {
  late Vector2 canvasSize;
  Timer? longPressTimer;
  Timer? waitLongPressTimer;
  Timer? shakeAnimationTimer;
  Timer? splashAnimationTimer;
  int timeSincePressed = 0;
  int timeSinceLastShake = 0;
  int timeSinceAnimationStart = 0;
  bool isSplashing = false;
  double hue = 0;
  String softDrink = "none";
  // late ShakeDetector shakeDetector;

  final softDrinksToInt = {
    "cola": 0,
    "fanta": 1,
    "sprite": 2,
    "pepsi": 3,
    "grape": 4,
  };

  @override
  void initState() {
    super.initState();
    startListeningShake(15); //20 is the default threshold value for the shake event

    // ShakeDetector.autoStart(onPhoneShake: () {

    // });
  }

  @override
  Widget build(BuildContext context) {
    canvasSize = Vector2(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    return GestureDetector(
      onTapDown: onBackgroundTapDown,
      onPanEnd: (DragEndDetails _) {
        onTapUp();
      }, //when u dragged before releasing your finger
      onTapUp: (TapUpDetails _) {
        onTapUp();
      }, //when u did not drag
      // onLongPress: onLongPress,
      // onLongPressUp: onLongPressUp,
      child: ChangeColors(
        hue: hue,
        brightness: getBrightness(hue),
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.Colors.red[900], //the color is necessary or else taps outside the cookie cannot be registered
            child: Stack(
              children: [
                Positioned(
                  child: timeSincePressed != 0
                      ? LinearProgressIndicator(
                          value: timeSincePressed / 30,
                          color: Colors.Colors.green[800],
                          backgroundColor: Colors.Colors.green[300],
                          minHeight: 10,
                        )
                      : const SizedBox(),
                ),
                Positioned(
                  left: canvasSize.x / 2 - 100 / 2,
                  top: canvasSize.y / 2 -
                      190 / 2 -
                      80, //! this is the approximate height of the header (specified in MyApp.dart)
                  width: 100,
                  height: 190,
                  child: Transform.rotate(
                    angle: _calculateAngle(timeSinceAnimationStart),
                    child: softDrink == "none"
                        ? Image(
                            width: 100,
                            height: 190,
                            image: AssetImage('assets/images/softDrinks/' + softDrink + '.png'),
                          )
                        : ChangeColors(
                            hue: -hue,
                            brightness: -getBrightness(hue),
                            child: Image(
                              width: 100,
                              height: 190,
                              image: AssetImage('assets/images/softDrinks/' + softDrink + '.png'),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  left: canvasSize.x / 2 - 100 / 2,
                  top: canvasSize.y / 2 -
                      190 / 2 -
                      100 //higher than the coke by 100 px
                      -
                      80, //! this is the approximate height of the header (specified in MyApp.dart)
                  width: 100,
                  height: 100,
                  child: isSplashing
                      ? ChangeColors(
                          hue: -hue,
                          brightness: -getBrightness(hue),
                          child: Image(
                            width: 100,
                            height: 100,
                            image: AssetImage('assets/images/splashs/' + softDrink + '.png'),
                          ),
                        )
                      : Container(),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void onBackgroundTapDown(TapDownDetails details) {
    print("tapDown");
    widget.p.tap(1.0);

    if ((waitLongPressTimer == null || !waitLongPressTimer!.isActive) &&
        (longPressTimer == null || !longPressTimer!.isActive)) {
      timeSincePressed = 0;
      waitLongPressTimer = Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
        setState(() {
          timeSincePressed += 1;
        });
        if (timeSincePressed == 30) {
          onLongPress();
          t.cancel();
        }
      });
    }
  }

  void onTapUp() {
    print("onTapUp");
    if (timeSincePressed >= 30) {
      onLongPressUp();
    }
    setState(() {
      timeSincePressed = 0;
    });
    waitLongPressTimer?.cancel();
  }

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

  String getAndRecordSoftDrink(double hue) {
    final softDrinkString = getSoftDrink(hue);
    if (softDrinkString != "none") {
      widget.p.progressSecret(14, 0, amount: softDrinksToInt[softDrinkString]!, isBitmap: true);
    }
    return softDrinkString;
  }

  void recordSoftDrinkShake() {
    final softDrinkString = getSoftDrink(hue);
    if (softDrinkString != "none") {
      widget.p.progressSecret(15, 0, amount: softDrinksToInt[softDrinkString]!, isBitmap: true);
    }
  }

  void onLongPressUp() {
    longPressTimer?.cancel();
    var softDrink = getAndRecordSoftDrink(hue);
    print("onLongPressUp, softDrink: " + softDrink);
    if (softDrink == "fanta") {
      widget.p.progressSecret(12, 0);
    }
    if (softDrink == "pepsi") {
      widget.p.progressSecret(13, 0);
    }

    setState(() {
      this.softDrink = softDrink;
    });
  }

  @override
  shakeEventListener() {
    //DO ACTIONS HERE
    print("SHAKE");
    //prerequisite: not long pressing
    if ((waitLongPressTimer == null || !waitLongPressTimer!.isActive) &&
        (longPressTimer == null || !longPressTimer!.isActive)) {
      timeSinceLastShake = 0;
      if (!isSplashing && (shakeAnimationTimer == null || shakeAnimationTimer?.isActive == false)) {
        print("start shake timer");
        Functions.vibrate();
        shakeAnimationTimer = Timer.periodic(const Duration(milliseconds: 33), (Timer t) {
          //1/30 seconds per fire
          if (!mounted) {
            t.cancel();
          }

          //disable long press while shaking, to prevent people accidentally leaving the current can while shaking.
          waitLongPressTimer?.cancel();
          longPressTimer?.cancel();

          setState(() {
            timeSinceLastShake += 1;
            timeSinceAnimationStart += 1;
          });
          if (timeSinceLastShake >= 60) {
            timeSinceAnimationStart = 0;
            t.cancel();
            print("stop shake timer");
          }

          //if shake animation for more than 2 seconds (i.e. phone shaked once, no duration requirement now (because it samples every 0.5 secs))
          print(timeSinceAnimationStart);
          if (timeSinceAnimationStart >= 59 &&
              (splashAnimationTimer == null || splashAnimationTimer?.isActive == false)) {
            widget.p.progressSecret(10, 0);
            recordSoftDrinkShake();
            setState(() {
              isSplashing = true;
            });
            splashAnimationTimer = Timer(const Duration(seconds: 3), () {
              if (!mounted) {
                t.cancel();
              }
              setState(() {
                isSplashing = false;
              });
            });
            timeSinceAnimationStart = 0;
            t.cancel();
            print("stop shake timer due to splash");
          }
        });
      }
    }
    return super.shakeEventListener();
  }

  @override
  void dispose() {
    longPressTimer?.cancel();
    waitLongPressTimer?.cancel();
    shakeAnimationTimer?.cancel();
    splashAnimationTimer?.cancel();
    resetShakeListeners();
    super.dispose();
  }

  double _calculateAngle(int timeSinceAnimationStart) {
    double t = timeSinceAnimationStart % 16;
    // print(timeSinceAnimationStart.toString());
    if (t <= 4) {
      return 0.15 * t;
    } else if (t <= 12) {
      return 0.75 - (t - 4) * 0.15;
    } else {
      return 0.15 * (t - 16);
    }
  }
}
