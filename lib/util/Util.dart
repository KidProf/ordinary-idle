import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

mixin Util {
  static String doubleRepresentation(double value) {
    if (value < 100000) {
      //10^5
      final f = NumberFormat("##0.00", "en_GB");
      return f.format(_roundDouble(value, 2));
    } else {
      return value
          .toStringAsExponential(3)
          .runes
          .where((int c) => c != 43)
          .map((int c) => String.fromCharCode(c))
          .join();
      //to remove the + sign (with ASCII = 43), but complications emerge when converting from strings to list of characters and vice versa
    }
  }

  static double _roundDouble(double value, int places) {
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
    backgroundColor: MaterialStateProperty.all<Color>(disabled),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: disabled),
      ),
    ),
  );

  static const Color disabled = Colors.black54;

  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle subtitleStyle = TextStyle(fontSize: 25);

  //normally used to build body of pages
  //if you want to center something, warp it with a Row and use flex center
  //for text: textAlign: TextAlign.center,
  static Widget WarpBody({required BuildContext context, required List<Widget> children, double? spacing}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: spacing ?? 15,
        children: children
            .map((Widget w) => SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  child: w,
                ))
            .toList(),
      ),
    );
  }

  static Widget divider() => const Divider(color: Colors.black45);

  static void launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
