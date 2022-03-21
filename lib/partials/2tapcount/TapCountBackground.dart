import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/util/Background.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:tuple/tuple.dart';
import 'package:vector_math/vector_math.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class TapCountBackground extends StatefulWidget {
  final Secrets pSecrets;
  final Function(double) tap;

  TapCountBackground(this.pSecrets, this.tap, {Key? key}) : super(key: key);

  @override
  State<TapCountBackground> createState() => _TapCountBackgroundState();
}

class _TapCountBackgroundState extends State<TapCountBackground>
    implements Background {
  late Vector2 canvasSize;
  late Timer? lolTimer = null;
  final tapStyle = const TextStyle(fontSize: 130, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    canvasSize = Vector2(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    return NativeDeviceOrientationReader(
        useSensor: true,
        builder: (context) {
          return ValueListenableBuilder<Box>(
              valueListenable: Hive.box('currentSecretsV2')
                  .listenable(keys: [9999]), //listen to secret 9999 only
              builder: (context, box, _) {
                var taps = widget.pSecrets.secretProgress(9999).item2;
                bool isOverflow = _isOverflow(taps.toString(), canvasSize.x);
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  _checkSecrets(context);
                });

                return GestureDetector(
                  onTapDown: onBackgroundTapDown,
                  child: Container(
                    color: Colors.Colors.green[
                        100], //the color is necessary or else taps outside the cookie cannot be registered
                    child: Column(
                      children: [
                        SizedBox(height: 0),
                        Container(
                          alignment: Alignment.center,
                          child: isOverflow
                              ? const Icon(CupertinoIcons.infinite, size: 130)
                              : Text(
                                  taps != 303 ? taps.toString() : "LOL",
                                  style: tapStyle,
                                ),
                        ),
                        ElevatedButton(
                          child: Text("Reset Count"),
                          onPressed: () {
                            widget.pSecrets.resetSecretProgression(9999);
                          },
                        ),
                        // ElevatedButton(
                        //   child: Text("+300"), //FIXME: do not put this to release!!!
                        //   onPressed: () {
                        //     widget.pSecrets.progressSecret(9999, 0, amount: 300);
                        //   },
                        // ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                );
              });
        });
  }

  @override
  void onBackgroundTapDown(TapDownDetails details) {
    widget.tap(1.0);
    widget.pSecrets.progressSecret(9999, 0);
  }

  void _checkSecrets(BuildContext context) {
    var taps = widget.pSecrets.secretProgress(9999).item2;

    //Secret 5,6
    final orientation = NativeDeviceOrientationReader.orientation(context);
    print('Received new orientation: $orientation');
    if (orientation == NativeDeviceOrientation.portraitDown) {
      //inverted
      if (_check69(taps)) {
        widget.pSecrets.progressSecret(5, 0);
      }
      var inverted = _invert(taps);
      print(inverted);
      if (inverted.item1 == true && inverted.item2 >= taps + 700) {
        widget.pSecrets.progressSecret(6, 0);
      }
    }

    //Secret 7
    bool isOverflow = _isOverflow(taps.toString(), canvasSize.x);
    if (isOverflow) {
      widget.pSecrets.progressSecret(7, 0);
    }

    //Secret 8
    if (taps == 303) {
      //activate timer
      print("timer fired");
      lolTimer = Timer(const Duration(seconds: 5), () {
        if (widget.pSecrets.secretProgress(9999).item2 == 303) {
          //check if it is still 303
          widget.pSecrets.progressSecret(8, 0);
        } else {
          print(
              "timer finished but secret not progressed because number changed");
        }
      });
    }
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
    return size.width > canvasX || canvasX > 400;
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
    if(taps==0) return false;
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
    print("timer cancelled in dispose");
    super.dispose();
  }
}
