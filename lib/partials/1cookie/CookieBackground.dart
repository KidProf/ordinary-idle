import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart' as Colors;
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:ordinary_idle/util/SwipeDetector.dart';
import 'package:vector_math/vector_math.dart';


class CookieBackground extends StatefulWidget {
  final Function addCoins;
  final Secrets pSecrets;

  const CookieBackground(this.pSecrets, this.addCoins, {Key? key})
      : super(key: key);

  @override
  State<CookieBackground> createState() => _CookieBackgroundState();
}

class _CookieBackgroundState extends State<CookieBackground> {
  late Vector2 canvasSize;
  late Vector2 canvasCenter;
  late Vector2 cookieCenter;
  Vector2 cookieOffset = Vector2.zero();
  double cookieSize = 300;
  double sensitivity = 50;
  bool cookieShow = true;

  @override
  Widget build(BuildContext context) {
    canvasSize = Vector2(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height,);
    canvasCenter = Vector2(canvasSize.x / 2, canvasSize.y / 2);
    cookieCenter = canvasCenter +
        cookieOffset;
    return SwipeDetector(
        onSwipeUp: () {
          if(widget.pSecrets.prerequisiteMet(3)&&!widget.pSecrets.secretCompleted(3)){
            if(cookieOffset.y<-canvasSize.y*0.42){
            setState(() {
              cookieShow = false;
            });
            widget.pSecrets.progressSecret(3,0);
            print("completed");
          }else{
            setState(() {
              cookieOffset += Vector2(0, -canvasSize.y*0.06);
            });
          }
          }        
          print("swipe up" + cookieOffset.toString());
        },
        filterOnStart: (DragStartDetails dragDetails) {
          print(_isInCookie(
              dragDetails.globalPosition.dx, dragDetails.globalPosition.dy));
          return _isInCookie(
              dragDetails.globalPosition.dx, dragDetails.globalPosition.dy);
        },
        child: GestureDetector(
            // When the child is tapped, show a snackbar.
            onTapDown: _onBackgroundTapDown,
            // onTapUp: _onTapUp,
            // The custom button
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFFAFAFA), //the color is necessary or else taps outside the cookie cannot be registered
              child: Stack(
                children: [
                  Positioned(
                    left: cookieCenter.x - cookieSize / 2,
                    top: cookieCenter.y - cookieSize / 2,
                    height: cookieSize,
                    width: cookieSize,
                    child: cookieShow ? const Image(
                      image: AssetImage('assets/images/cookie.png'),
                    ) : Container(),
                  ),
                ],
              ),
            )));
  }

  _onBackgroundTapDown(TapDownDetails details) {
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    // or user the local position method to get the offset
    // print(details.localPosition);
    print("tap down " + x.toString() + ", " + y.toString());
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
    if(!cookieShow) return false; 
    double result = (x - cookieCenter.x) * (x - cookieCenter.x) +
        (y - cookieCenter.y) * (y - cookieCenter.y) -
        (cookieSize / 2) * (cookieSize / 2);
    return result <= 0;
  }
}
