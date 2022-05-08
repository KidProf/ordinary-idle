import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/util/CustomIcons.dart';
import 'package:ordinary_idle/util/Functions.dart';

//! Please change CookieBackground to match the height of the header (specified in MyApp.dart)
class ValueHeader extends StatelessWidget {
  final Player p;
  final int selectedIndex;
  late Map<String, dynamic> vitals = p.vitals.value;

  ValueHeader(this.p, this.selectedIndex, {Key? key}) : super(key: key);

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
              GestureDetector(
                onTap: () async {
                  Functions.showMultiplierDialog(
                    p: p,
                    actions: [
                      {"text": "Close"}
                    ],
                    context: context,
                  );
                },
                child: Text(
                  Functions.doubleRepresentation(vitals["multiplier"]) + "x",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: double.infinity,
          child: Wrap(
            children: selectedIndex != 2
                ? [
                    Text("CPS:" + Functions.doubleRepresentation(vitals["coinsPerSecond"] * vitals["multiplier"])),
                    Text("CPT:" + Functions.doubleRepresentation(vitals["coinsPerTap"] * vitals["multiplier"])),
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
