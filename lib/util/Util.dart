import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin Util {
  static String doubleRepresentation(double value) {
    final f = NumberFormat("##0.00", "en_GB");
    double mod = pow(10.0, 2).toDouble(); // 2 dp for now
    return f.format((value * mod).round().toDouble() / mod);
  }

  static final ButtonStyle greenRounded = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: Colors.green),
      ),
    ),
  );

  static final ButtonStyle disabledRounded = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black54),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: Colors.black54),
      ),
    ),
  );
}
