import 'package:flutter/material.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:vector_math/vector_math.dart';

class CookieBackground extends StatefulWidget {
  final Function addCoins;
  final Secrets pSecrets;

  const CookieBackground(this.pSecrets, this.addCoins, {Key? key}) : super(key: key);

  @override
  State<CookieBackground> createState() => _CookieBackgroundState();
}

class _CookieBackgroundState extends State<CookieBackground> {
  late Vector2 canvasSize;
  late Vector2 canvasCenter;
  late Vector2 cookieCenter;
  Vector2 cookieOffset = Vector2.zero();
  double cookieSize = 300;

  @override
  Widget build(BuildContext context) {
    canvasSize = Vector2(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    canvasCenter = Vector2(canvasSize.x / 2, canvasSize.y / 2);
    cookieCenter = canvasCenter + cookieOffset; //Vector2(canvasCenter.x+cookieOffset.x,canvasCenter.y+cookieOffset.y);

    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTapDown: _onBackgroundTapDown,
      // onTapUp: _onTapUp,
      // The custom button
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image(image: AssetImage('assets/images/cookie.png'), height: 300, width: 300),
      ),
    );
  }

  _onBackgroundTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    // print(details.localPosition);
    // print("tap down " + x.toString() + ", " + y.toString());
    widget.addCoins(1.0);
    if (_isInCookie(x, y)) {
      //TODO: animations of some sort
    } else {
      widget.pSecrets.progressSecret(2, 0);
    }
  }

  // _onTapUp(TapUpDetails details) {
  // }

  bool _isInCookie(double x, double y) {
    double result = (x - cookieCenter.x) * (x - cookieCenter.x) +
        (y - cookieCenter.y) * (y - cookieCenter.y) -
        (cookieSize / 2) * (cookieSize / 2);
    return result <= 0;
  }
}
