import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ordinary_idle/util/CustomIcons.dart';

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
          Flexible(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSecretToast(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.amber[800],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_open_outlined),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildAchievementToast(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green[300],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CustomIcons.trophy),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.black),
            ),
          ),
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
            bottom: 150.0,
            left: 0.0,
            right: 0.0,
          );
        });
  }

  static void showSecretToast(FToast fToast, String msg) {
    fToast.showToast(
        child: _buildSecretToast(msg),
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: Align(alignment: Alignment.center, child: child),
            bottom: 150.0,
            left: 0.0,
            right: 0.0,
          );
        });
  }

  static void showAchievementToast(FToast fToast, String msg) {
    fToast.showToast(
        child: _buildAchievementToast(msg),
        toastDuration: const Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: Align(alignment: Alignment.center, child: child),
            bottom: 150.0,
            left: 0.0,
            right: 0.0,
          );
        });
  }
}
