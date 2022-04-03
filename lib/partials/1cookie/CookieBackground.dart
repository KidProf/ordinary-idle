import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/util/Background.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/util/SwipeDetector.dart';
import 'package:vector_math/vector_math.dart';

import 'package:ordinary_idle/util/RotateDetector.dart';

class CookieBackground extends StatefulWidget {
  final Player p;

  const CookieBackground(this.p, {Key? key}) : super(key: key);

  @override
  State<CookieBackground> createState() => _CookieBackgroundState();
}

class _CookieBackgroundState extends State<CookieBackground> implements Background {
  late Vector2 canvasSize;
  late Vector2 canvasCenter;
  late Vector2 cookieCenter;
  Vector2 cookieOffset = Vector2.zero();
  double cookieSize = 300;
  bool cookieShow = true;

  //for secret 4
  double cookieAngle = 0; //rotation of cookie displayed
  double internalAngle = 0; //actual rotation of cookie (including anticlockwise)
  double fingerCookieOffset = 0; //cookieAngle = fingerAngle - fingerCookieOffset
  double secret4Progression = 0;
  bool secret4Completed = false; //so that the animation could play

  @override
  Widget build(BuildContext context) {
    canvasSize = Vector2(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );
    canvasCenter = Vector2(canvasSize.x / 2, canvasSize.y / 2);
    cookieCenter = canvasCenter + cookieOffset;

    //! temporary: secret4Completed = set to whether secret has unlocked before, so that rotation animation would persist, but have to switch to secret 5 later
    secret4Completed = widget.p.secretCompleted(4);

    var gestureChild = GestureDetector(
        onTapDown: onBackgroundTapDown,
        // onTapUp: _onTapUp,
        // The custom button
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.Colors.amber[100], //the color is necessary or else taps outside the cookie cannot be registered
          child: Stack(
            children: [
              Positioned(
                left: cookieCenter.x - cookieSize / 2,
                top: cookieCenter.y -
                    cookieSize / 2 -
                    80, //! this is the approximate height of the header (specified in MyApp.dart)
                height: cookieSize,
                width: cookieSize,
                child: cookieShow
                    ? Transform.rotate(
                        angle: -cookieAngle,
                        child: const Image(
                          image: AssetImage('assets/images/cookie.png'),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ));
    if (widget.p.secretDoable(3)) {
      return _swipeDetectorSecret3(gestureChild);
    } else if (widget.p.secretDoable(4) || secret4Completed) {
      return _panDetectorSecret4(gestureChild);
    } else {
      return gestureChild;
    }
  }

  @override
  onBackgroundTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    // print(details.localPosition);
    // print("tap down " + x.toString() + ", " + y.toString());
    widget.p.tap(1.0);
    // print((x - cookieCenter.x) * (x - cookieCenter.x) +
    //     (y - cookieCenter.y) * (y - cookieCenter.y));
    // print(Vector2(x - cookieCenter.x,y-cookieCenter.y));
    if (_isInCookie(x, y)) {
      //TODO: animations of some sort
      // setState(() {
      //   cookieAngle += 0.1;
      // });
    } else {
      widget.p.progressSecret(2, 0);
    }
  }

  // _onTapUp(TapUpDetails details) {
  // }

  double _squaredDistanceFromCenter(double x, double y) {
    return (x - cookieCenter.x) * (x - cookieCenter.x) + (y - cookieCenter.y) * (y - cookieCenter.y);
  }

  bool _isInCookie(double x, double y) {
    if (!cookieShow) return false;
    double result = _squaredDistanceFromCenter(x, y) - (cookieSize / 2) * (cookieSize / 2);
    return result <= 0;
  }

  bool _isInCookieTolerance(double x, double y) {
    if (!cookieShow) return false;
    double result = _squaredDistanceFromCenter(x, y) - (cookieSize * 3 / 4) * (cookieSize * 3 / 4); //1.5*radius
    return result <= 0;
  }

  Widget _swipeDetectorSecret3(Widget child) {
    return SwipeDetector(
      onSwipeUp: widget.p.secretDoable(3)
          ? () {
              if (cookieOffset.y < -canvasSize.y * 0.35) {
                setState(() {
                  cookieShow = false;
                });
                widget.p.progressSecret(3, 0);
              } else {
                setState(() {
                  cookieOffset += Vector2(0, -canvasSize.y * 0.05);
                });
              }
              print("swipe up" + cookieOffset.toString());
            }
          : null,
      swipeConfiguration: SwipeConfiguration(
        verticalSwipeMaxWidthThreshold: 100,
        verticalSwipeMinVelocity: 150,
        verticalSwipeMinDisplacement: 50,
      ),
      filterOnStart: (DragStartDetails dragDetails) {
        return _isInCookieTolerance(dragDetails.globalPosition.dx, dragDetails.globalPosition.dy);
      },
      child: child,
    );
  }

  Widget _panDetectorSecret4(Widget child) {
    return RotateDetector(
      getAngleOffset: _getAngleOffset,
      onAngleChange: _onAngleChange,
      filterOnStart: (DragStartDetails dragDetails) {
        return _isInCookieTolerance(dragDetails.globalPosition.dx, dragDetails.globalPosition.dy);
      },
      center: cookieCenter,
      child: child,
    );
  }

  _getAngleOffset(double offset) {
    fingerCookieOffset = offset - cookieAngle;
    print(fingerCookieOffset);
  }

  _onAngleChange(double fingerAngle) {
    var newInternalAngle = fingerAngle - fingerCookieOffset % (2 * pi);
    if ((newInternalAngle - internalAngle) % (2 * pi) > pi || secret4Completed) {
      //clockwise, OK
      secret4Progression = 0;
      print("clockwise");
      internalAngle = newInternalAngle;
      setState(() {
        cookieAngle = internalAngle;
      });
    } else {
      print("anticlockwise");
      print(secret4Progression);
      internalAngle = newInternalAngle;
      while (newInternalAngle < secret4Progression) {
        newInternalAngle += 2 * pi;
      }
      secret4Progression = newInternalAngle;
      if (secret4Progression > 8 * pi) {
        //4 cycles
        widget.p.progressSecret(4, 0);
        secret4Completed = true;
        setState(() {
          cookieAngle = internalAngle;
        });
      }
    }
  }
}
