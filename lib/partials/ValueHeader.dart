import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Money.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/util/CustomIcons.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:ordinary_idle/util/Styles.dart';

//! Please change CookieBackground to match the height of the header (specified in MyApp.dart)
class ValueHeader extends StatelessWidget {
  final Player p;
  final int selectedIndex;
  final Function(int, BuildContext) onItemTapped;
  late Map<String, dynamic> vitals = p.vitals.value;
  
  ValueHeader(this.p, this.selectedIndex, this.onItemTapped, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prestigeCriteria = Functions.prestigeCriteria(p.getMMax());
    final canPrestige = Functions.canPrestige(p.getMMax(), p.getPrevMMax());

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
                  if (prestigeCriteria) {
                          Functions.showMultiplierDialog(
                              p: p,
                              newPrestigeMultiplier: true,
                              actions: [
                                {
                                  "text": "Cancel",
                                  "color": Colors.red,
                                },
                                {
                                  "text": "Confirm",
                                  "color": canPrestige ? Styles.gold : Styles.disabled,
                                  "action": () async {
                                    if (canPrestige) {
                                      await Functions.prestige(p, context, onItemTapped);
                                    } else {
                                      MyToast.showBottomToast(p.fToast,
                                          "The maximum coins you have must be larger than your previous runs.");
                                    }
                                  }
                                }
                              ],
                              context: context,
                              extraMessage:
                                  "All your coins and purchases in the main shop will be reset, achievements and secrets will not.");
                        }
                },
                child: Stack(
                  children: [
                    //the text itself
                    Text(
                      Functions.doubleRepresentation(vitals["multiplier"]) + "x",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: canPrestige ? Styles.gold: Colors.white,
                      ),
                    ),
                    //the gold border of the text
                    ...canPrestige ? [
                      Text(
                      Functions.doubleRepresentation(vitals["multiplier"]) + "x",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        // color: canPrestige ? Styles.gold: Colors.white,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 0.0
                          ..color = Colors.white,
                      ),
                    ),
                    ] : [],
                  ],
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
