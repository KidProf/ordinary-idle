import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  final BuildContext context;
  MyToast(this.context);

  static Widget _buildToast(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black87,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.check),
          // SizedBox(
          //   width: 12.0,
          // ),
          Text(msg,style: const TextStyle(color: Colors.white),),
        ],
      ),
    );
  }

  // Custom Toast Position
  static void showBottomToast(FToast fToast, String msg) {
    fToast.showToast(
        child: _buildToast(msg),
        toastDuration: const Duration(seconds: 1),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: Align(alignment: Alignment.center, child: child),
            bottom: 100.0,
            left: 0.0,
            right: 0.0,
          );
        });
  }
}
