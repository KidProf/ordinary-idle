import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin Util {
  static String doubleRepresentation(double value) {
    if(value<100000){ //10^5
      final f = NumberFormat("##0.00", "en_GB");
      return f.format(_roundDouble(value,2));
    }else{
      return value.toStringAsExponential(3).runes.where((int c)=>c!=43).map((int c)=>String.fromCharCode(c)).join(); 
      //to remove the + sign (with ASCII = 43), but complications emerge when converting from strings to list of characters and vice versa
    }
  }

  static double _roundDouble(double value, int places){
    double mod = pow(10.0, 2).toDouble(); // 2 dp for now
    return (value * mod).round().toDouble() / mod;
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
