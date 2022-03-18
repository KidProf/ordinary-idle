import 'package:flutter/material.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Util.dart';

//FIXME: Please change CookieBackground to match the height of the header (specified in MyApp.dart)
class ValueHeader extends StatelessWidget {
  final Map<String, dynamic> vitals;

  const ValueHeader(this.vitals, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 10),
        Row(
          children: [
            const Image(
                image: AssetImage('assets/images/coin.png'),
                width: 30,
                height: 30),
            const SizedBox(width: 10),
            Text(
              Money.vitalsRepresentation(vitals),
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(width: 50),
            Text(
              vitals["multiplier"].toString() + "x",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        const SizedBox(width: 10),
        Container(
          width: double.infinity,
          child: Wrap(
            children: [
              Text(
                  "CPS:" + Util.doubleRepresentation(vitals["coinsPerSecond"])),
              Text("CPT:" + Util.doubleRepresentation(vitals["coinsPerTap"])),
            ],
            alignment: WrapAlignment.spaceBetween,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
