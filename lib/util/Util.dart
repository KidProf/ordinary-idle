import 'dart:math';

import 'package:intl/intl.dart';

mixin Util {
  static String doubleRepresentation(double value) {
    final f = NumberFormat("##0.00", "en_GB");
    double mod = pow(10.0, 2).toDouble(); // 2 dp for now
    return f.format((value * mod).round().toDouble() / mod);
  }
}
