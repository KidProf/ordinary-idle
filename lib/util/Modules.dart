import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

mixin Modules {
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

  static List<Widget> webWarning({bool needPaddingBelow = true}) {
    if (kIsWeb) {
      return [
        Text(
            "WARNING: You are using the web version of OrdinaryIdle, download the app for the best experience, including the ability to discover secrets that require phone gestures and progress storage. (Now available on Google Play only)",
            style: TextStyle(color: Colors.red)),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                Functions.launchURL("https://play.google.com/store/apps/details?id=com.kidprof.ordinaryidle");
              },
              child: Text("Google Play"),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        needPaddingBelow ? SizedBox(height: 10) : Modules.divider(),
      ];
    } else {
      return [];
    }
  }
}
