import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Achievements.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/main.dart';
import 'package:ordinary_idle/model/PlayerT3.dart';
import 'package:ordinary_idle/util/CustomIcons.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:ordinary_idle/util/Modules.dart';
import 'package:ordinary_idle/util/MyToast.dart';
import 'package:ordinary_idle/util/Styles.dart';

class AchievementsPage extends StatelessWidget {
  final Player p;
  final Function(int, BuildContext) onItemTapped;

  const AchievementsPage(this.p, this.onItemTapped, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ValueListenableBuilder<Box>(
          valueListenable: PlayerT3.getBox().listenable(keys: ["achievementsLevel", "achievementsParam"]),
          builder: (context, _, __) {
            final canPrestige = Functions.canPrestigeByP(p);
            final prestigeCriteria = Functions.prestigeCriteriaByP(p);
            //1e7 and higher than last prestige

            return Modules.WarpBody(
              context: context,
              children: [
                const SizedBox(height: 10),
                ...Modules.webWarning(),
                const Text("Prestige", style: Styles.subtitleStyle),
                const SizedBox(height: 10),
                const Text(
                    "Reset all the coins and purchases in the main shop for faster progression in the long run. It will also bring you to another theme which unlocks the possibility of finding different secrets."),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(prestigeCriteria ? Color(0xFFD4AF37) : Styles.disabled),
                      ),
                      onPressed: () async {
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
                        } else {
                          MyToast.showBottomToast(p.fToast, "Reach 1e7 coins to unlock prestige.");
                        }
                      },
                      child: Text("Prestige"),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Modules.divider(),
                const Text("Achievements", style: Styles.titleStyle),
                const SizedBox(height: 10),
                const Text(
                    "These are obvious goals of the idle game, for example reaching certain amount in money. It is also here to tell you the secrets are not about doing these things below."),
                const SizedBox(height: 10),
                const Text(
                    "NOTE: The trophies currently have no use other than making you feel proud of yourself. Its use will be introduced later, but it will definitely take some time."),
                const SizedBox(height: 10),
                ..._printSecrets(p, context),
              ],
              spacing: 0,
            );
          }),
    );
  }

  List<Widget> _printSecrets(Player p, BuildContext context) {
    var aTypes = Achievements.achievementTypes;
    aTypes.sort((a, b) => a.id - b.id); //asc id

    var widgets = aTypes.map((AchievementType aType) {
      final int currentLevel = p.getAchievementLevel(aType.exid);
      List<Widget> widgetsType;
      if (aType.id == 1) {
        //just without the divider and spacing above generally
        widgetsType = [
          Text(aType.title, style: Styles.subtitleStyle),
        ];
      } else {
        widgetsType = [
          Modules.divider(),
          const SizedBox(height: 10),
          Text(aType.title, style: Styles.subtitleStyle),
        ];
      }
      for (var i = 0; i < aType.children.length; i++) {
        //cannot use map because the index of the element has to be known
        final formattedProgress = (p.getAchievementProgress(aType.id, i) * 100).toInt().toString() + "%";
        widgetsType.add(_printAchievement(
            p, context, aType.children[i], aType.descriptionI(i), currentLevel >= i, formattedProgress));
      }
      return widgetsType;
    });
    return widgets.expand((x) => x).toList();
  }

  Widget _printAchievement(Secrets pSecrets, BuildContext context, Map<String, dynamic> child, String description,
      bool completed, String formattedProgress) {
    Color color = completed ? Colors.black : Colors.black38;
    return GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            border: Border.all(color: color),
          ),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                child["title"],
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              )),
              const SizedBox(width: 10),
              Text(completed ? child["reward"].toString() : formattedProgress,
                  style: TextStyle(fontSize: 20, color: color)),
              const SizedBox(width: 5),
              Icon(CustomIcons.trophy, size: 20, color: completed ? Colors.amber[800] : Colors.grey),
              const SizedBox(width: 10),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        onTap: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Modules.WarpBody(
                context: context,
                children: [
                  const SizedBox(height: 0),
                  Text(
                    child["title"],
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(description),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              );
            },
          );
        });
  }
}
