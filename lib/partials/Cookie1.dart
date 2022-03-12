import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class Cookie extends FlameGame with TapDetector {
  late Vector2 screenSize;
  late Sprite cookie;
  final Function addCoins;

  Cookie(this.addCoins);

  @override
  Future<void>? onLoad() async {
    final cookieImage = await Flame.images.load("cookie.png");
    cookie = Sprite(cookieImage);
    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo e) {
    // print(addCoins(1.0));

    // if (e.raw.localPosition.dx >= screenCenterX - 75 &&
    //     e.raw.localPosition.dx <= screenCenterX + 75 &&
    //     e.raw.localPosition.dy >= screenCenterY - 75 &&
    //     e.raw.localPosition.dy <= screenCenterY + 75) {
    //   hasWon = true;
    // }
    return true;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    screenSize = canvasSize;
    super.onGameResize(canvasSize);
  }

  @override
  void render(Canvas canvas) async {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.x, screenSize.y);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xfffafafa);
    canvas.drawRect(bgRect, bgPaint);

    double screenCenterX = screenSize.x / 2;
    double screenCenterY = screenSize.y / 2;

    cookie.render(
      canvas,
      position: Vector2(screenCenterX - 150, screenCenterY - 150),
      size: Vector2(300, 300),
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
    super.render(canvas);
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}
