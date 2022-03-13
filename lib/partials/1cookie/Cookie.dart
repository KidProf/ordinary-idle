import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class Cookie extends PositionComponent with Tappable {
  static final Paint _grey = Paint()..color = const Color(0xFFA5A5A5);
  late Sprite cookie;
  late Vector2 screenSize;
  Cookie({Vector2? position}) : super(
    position: position ?? Vector2.all(300),
    size: Vector2.all(300),
  );

  @override
  Future<void> onLoad() async {
    final cookieImage = await Flame.images.load("cookie.png");
    cookie = Sprite(cookieImage);
    return super.onLoad();
  }
    
  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    double screenCenterX = screenSize.x / 2;
    double screenCenterY = screenSize.y / 2;
    // cookie.render(
    //   canvas,
    //   position: Vector2(screenCenterX - 150, screenCenterY - 150),
    //   size: Vector2(300, 300),
    // );
    canvas.drawRect(size.toRect(), _grey);
  }
  
  @override
  void onGameResize(Vector2 canvasSize) {
    screenSize = canvasSize;
    super.onGameResize(canvasSize);
  }

  @override
  bool onTapUp(TapUpInfo e) {
    print("onTapUp");
    return true;
  }

  @override
  bool onTapDown(TapDownInfo e) {
    print("onTapDown");
    // angle += 1.0;
    return true;
  }

  @override
  bool onTapCancel() {
    print("onTapCancel");
    return true;
  }
}
