import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/util/Background.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:tuple/tuple.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:vector_math/vector_math_64.dart';

class TapCountBackground extends StatefulWidget {
  final Player p;

  TapCountBackground(this.p, {Key? key}) : super(key: key);

  @override
  State<TapCountBackground> createState() => _TapCountBackgroundState();
}

class _TapCountBackgroundState extends State<TapCountBackground> implements Background {
  late Vector2 canvasSize;
  Timer? lolTimer;
  Timer? orientationTimer;
  NativeDeviceOrientation orientation = NativeDeviceOrientation.portraitUp;
  late int taps = widget.p.secretProgress(9999).item2;
  int analysingTaps = 0;
  String analysingString = "";
  final tapStyle = const TextStyle(fontSize: 130, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    canvasSize = Vector2(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );
    final child = ValueListenableBuilder<Box>(
        valueListenable: Hive.box('currentSecretsV2').listenable(keys: [9999]), //listen to secret 9999 only
        builder: (context, box, _) {
          // var taps = widget.p.secretProgress(9999).item2;
          bool isOverflow = _isOverflow(taps.toString(), canvasSize.x);
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            _checkOrientation(context);
          });

          return GestureDetector(
            onTapDown: onBackgroundTapDown,
            child: Container(
              color: Colors
                  .Colors.green[100], //the color is necessary or else taps outside the cookie cannot be registered
              child: Column(
                children: [
                  orientation == NativeDeviceOrientation.portraitDown
                      ? RotatedBox(
                          quarterTurns: 2,
                          child: Text(
                            analysingString,
                          ),
                        )
                      : SizedBox(height: 14),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      !_isLol(taps) ? taps.toString() : "LOL",
                      style: tapStyle,
                    ),
                  ),
                  ElevatedButton(
                    child: Text("Reset Count"),
                    onPressed: () {
                      widget.p.resetSecretProgression(9999);
                    },
                  ),
                  // ElevatedButton(
                  //   child: Text("+99"), //CRACK: do not put this to release!!!
                  //   onPressed: () {
                  //     widget.p.progressSecret(9999, 0, amount: 99);
                  //   },
                  // ),
                  // Text(
                  //   "Text Width: " +
                  //       _calcTextSize(
                  //         taps.toString(),
                  //         tapStyle,
                  //       ).width.toString() +
                  //       "     Canvas Width: " +
                  //       canvasSize.x.toString(),
                  // ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
          );
        });
    if (kIsWeb) {
      return child;
    } else {
      return NativeDeviceOrientationReader(
          useSensor: true,
          builder: (context) {
            return child;
          });
    }
  }

  @override
  void onBackgroundTapDown(TapDownDetails details) {
    widget.p.tap(1.0);
    if (widget.p.secretProgress(9999).item2 >= 1100) {
      widget.p.resetSecretProgression(9999);
      widget.p.progressSecret(9, 0);
    } else {
      widget.p.progressSecret(9999, 0);
    }
    setState(() {
      taps = widget.p.secretProgress(9999).item2;
    });
    _onTapsChanged();
  }

  void _onTapsChanged() {
    //Secret 7
    bool isOverflow = _isOverflow(taps.toString(), canvasSize.x);
    if (isOverflow) {
      widget.p.progressSecret(7, 0);
    }

    //Secret 8
    if (_isLol(taps)) {
      //activate timer
      print("lol timer fired");
      lolTimer = Timer(const Duration(seconds: 5), () {
        if (_isLol(widget.p.secretProgress(9999).item2)) {
          //check if it is still a lol number
          widget.p.progressSecret(8, 0);
        } else {
          print("timer finished but secret not progressed because number changed");
        }
      });
    }

    if (orientation == NativeDeviceOrientation.portraitDown) {
      orientationTimer?.cancel();
      _setUpOrientationTimer();
    }
  }

  void _checkInvertedSecrets() {
    var inverted = _invert(taps);

    //secrets 5,6
    if (_check69(taps)) {
      widget.p.progressSecret(5, 0);
      setState(() {
        analysingString = "Success! (69)";
      });
    } else if (inverted.item1 && inverted.item2 >= taps + 700) {
      widget.p.progressSecret(6, 0);
      setState(() {
        analysingString = "Success! (Change in perspective makes you feel better)";
      });
    } else {
      setState(() {
        analysingString = "Failed!";
      });
    }
  }

  void _checkOrientation(BuildContext context) {
    final newOrientation =
        kIsWeb ? NativeDeviceOrientation.portraitUp : NativeDeviceOrientationReader.orientation(context);
    if (newOrientation != orientation) {
      print('Received new orientation: $orientation');
      orientationTimer?.cancel();
      if (newOrientation == NativeDeviceOrientation.portraitDown) {
        _setUpOrientationTimer();
      }
      setState(() {
        orientation = newOrientation;
      });
    }
  }

  void _setUpOrientationTimer() {
    setState(() {
      analysingString = "Analysing...";
      analysingTaps = taps;
    });
    orientationTimer = Timer(const Duration(seconds: 2), () {
      print("orientationTimer fired taps: $taps, analysingTaps: $analysingTaps");
      if (taps == analysingTaps) {
        _checkInvertedSecrets();
      }
    });
  }

  bool _isLol(int taps) {
    return taps == 303 || taps == 505 || taps == 707;
  }

  bool _isOverflow(String text, double canvasX) {
    var size = _calcTextSize(
      text,
      tapStyle,
    );
    // print("text width: " +
    //     size.width.toString() +
    //     ", canvas width: " +
    //     canvasX.toString());
    return size.width > canvasX || size.width > 400;
  }

  Size _calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }

  bool _check69(int taps) {
    if (taps == 0) return false;
    while (taps > 0) {
      var digit = taps % 10;
      if (digit != 6 && digit != 9) return false;
      taps = taps ~/ 10;
    }
    return true;
  }

  Tuple2<bool, int> _invert(taps) {
    var strTaps = taps.toString().runes.map((int c) => String.fromCharCode(c));
    var inverted = 0;
    var multiplier = 1;
    for (String c in strTaps) {
      // for each character from left to right
      switch (c) {
        case '0':
        case '1':
        case '8':
          inverted += multiplier * (c.runes.first - 48);
          break;
        case '9':
          inverted += multiplier * 6;
          break;
        case '6':
          inverted += multiplier * 9;
          break;
        default:
          return Tuple2(false, 0);
      }
      multiplier *= 10;
    }

    return Tuple2(true, inverted);
  }

  @override
  void dispose() {
    lolTimer?.cancel();
    orientationTimer?.cancel();
    print("timer cancelled in dispose");
    super.dispose();
  }
}
