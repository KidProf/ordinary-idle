import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ordinary_idle/partials/1cookie/Cookie.dart';

class CookieBackground extends FlameGame with HasTappables {
  late Vector2 screenSize;
  late Cookie cookie;
  late SpriteButton cookieButton;
  final Function addCoins;

  CookieBackground(this.addCoins);

  @override
  Future<void>? onLoad() async {
    await add(cookie = Cookie(/*position: Vector2(screenSize.x / 2 - 150, screenSize.y /2 - 150)*/));

    // cookieButton = SpriteButton(
    //   sprite: cookie,
    //   pressedSprite: cookie,
    //   height: 300,
    //   width: 300,
    //   label: const Text("Cookie"),
    //   onPressed: () {
    //     print("pressed cookie"); //TODO: get it working
    //   },
    // );
    return super.onLoad();
  }

  @override
  void onTapDown(int x, TapDownInfo e) {
    print("backgroundOnTapDown");
    addCoins(1.0);

    // if (e.raw.localPosition.dx >= screenCenterX - 75 &&
    //     e.raw.localPosition.dx <= screenCenterX + 75 &&
    //     e.raw.localPosition.dy >= screenCenterY - 75 &&
    //     e.raw.localPosition.dy <= screenCenterY + 75) {
    //   hasWon = true;
    // }
    super.onTapDown(x, e);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    screenSize = canvasSize;
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) async {
    super.render(canvas);
    //white background
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.x, screenSize.y);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xfffafafa);
    canvas.drawRect(bgRect, bgPaint);

    cookie.render(
      canvas,
    );
    // Rect boxRect = Rect.fromLTWH(
    //   screenCenterX - 75,
    //   screenCenterY - 75,
    //   150,
    //   150
    // );

    // Paint boxPaint = Paint();
    // if (hasWon) {
    //   boxPaint.color = Color(0xff00ff00);
    // } else {
    //   boxPaint.color = Color(0xffffffff);
    // }
    // canvas.drawRect(boxRect, boxPaint);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}

// class TappableSquare extends PositionComponent with Tappable {
//   static final Paint _white = Paint()..color = const Color(0xFFFFFFFF);
//   static final Paint _grey = Paint()..color = const Color(0xFFA5A5A5);

//   bool _beenPressed = false;

//   TappableSquare({Vector2? position})
//       : super(
//           position: position ?? Vector2.all(100),
//           size: Vector2.all(100),
//         );

//   @override
//   void render(Canvas canvas) {
//     canvas.drawRect(size.toRect(), _beenPressed ? _grey : _white);
//   }

//   @override
//   bool onTapUp(_) {
//     _beenPressed = false;
//     return true;
//   }

//   @override
//   bool onTapDown(_) {
//     _beenPressed = true;
//     angle += 1.0;
//     return true;
//   }

//   @override
//   bool onTapCancel() {
//     _beenPressed = false;
//     return true;
//   }
// }