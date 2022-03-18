import 'dart:math';

import 'package:intl/intl.dart';

mixin Util{
  static String doubleRepresentation(double value, int places){ 
    final f = NumberFormat("###.00", "en_GB");
    double mod = pow(10.0, places).toDouble(); 
    return f.format((value * mod).round().toDouble() / mod); 
  }
  
}