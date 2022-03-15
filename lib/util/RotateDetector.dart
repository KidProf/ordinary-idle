import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class RotateDetector extends StatelessWidget {
  late Widget child;
  late Function(double)? getAngleOffset;
  late Function(double)? onAngleChange;
  late Function(DragEndDetails)? onPanEnd;
  late Vector2 center;

  RotateDetector({required this.child, this.getAngleOffset, this.onAngleChange, this.onPanEnd, Vector2? center}) {
    this.center = center ?? Vector2(0, 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _updateRotation,
      onPanEnd: onPanEnd,
      child: child,
    );
  }

  void _onPanStart(DragStartDetails details) {
    var x = details.globalPosition.dx - center.x;
    var y = details.globalPosition.dy - center.y;
    var fingerAngle = _calculateAngle(x, y);
    getAngleOffset!(fingerAngle);
  }

  void _updateRotation(DragUpdateDetails details) {
    var x = details.globalPosition.dx - center.x;
    var y = details.globalPosition.dy - center.y;
    var fingerAngle = _calculateAngle(x, y);
    if (onAngleChange != null) {
      onAngleChange!(fingerAngle);
    }
  }

  //calculate angle wrt standard convention (0 on right, pi/2 on top, pi on left, 3pi/2 on bottom)
  double _calculateAngle(double x, double y) {
    var rawAngle = atan(y / x);
    if (x > 0 && y > 0) {
      //Q4 in proper coordinate system (where y is upwards)
      return -rawAngle + 2 * pi;
    } else if (x > 0 && y < 0) {
      //Q1 in proper coordinate system (where y is upwards)
      return -rawAngle;
    } else {
      //Q2, Q3
      return -rawAngle + pi;
    }
  }
}
