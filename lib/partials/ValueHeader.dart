import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/util/CustomIcons.dart';
import 'package:ordinary_idle/util/Util.dart';

//! Please change CookieBackground to match the height of the header (specified in MyApp.dart)
class ValueHeader extends StatelessWidget {
  final Map<String, dynamic> vitals;
  final int selectedIndex;

  const ValueHeader(this.vitals, this.selectedIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(width: 10),
        Container(
          width: double.infinity,
          child: Wrap(
            children: [
              Row(
                children: [
                  const Image(image: AssetImage('assets/images/coin.png'), width: 30, height: 30),
                  const SizedBox(width: 10),
                  Text(
                    Money.vitalsRepresentation(vitals),
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
              ),
              Text(
                Util.doubleRepresentation(vitals["multiplier"]) + "x",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            alignment: WrapAlignment.spaceAround,
            direction: Axis.horizontal,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: double.infinity,
          child: Wrap(
            children: selectedIndex != 2
                ? [
                    Text("CPS:" + Util.doubleRepresentation(vitals["coinsPerSecond"] * vitals["multiplier"])),
                    Text("CPT:" + Util.doubleRepresentation(vitals["coinsPerTap"] * vitals["multiplier"])),
                  ]
                : [
                    Row(
                      children: [
                        Text(
                          vitals["trophies"].toString(),
                        ),
                        Icon(CustomIcons.trophy, size: 16, color: Colors.amber[800]),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
            alignment: WrapAlignment.spaceBetween,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
