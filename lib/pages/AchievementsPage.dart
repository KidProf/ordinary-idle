import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Achievements.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/data/Secrets.dart';
import 'package:ordinary_idle/util/CustomIcons.dart';
import 'package:ordinary_idle/util/Util.dart';

class AchievementsPage extends StatelessWidget {
  final Player p;
  const AchievementsPage(this.p, {Key? key}) : super(key: key);

  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box('player').listenable(keys: ["achievementsLevel"]),
          builder: (context, _, __) {
            return Util.WarpBody(
              context: context,
              children: [
                const SizedBox(height: 10),
                const Text("Achievements", style: titleStyle),
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

    var widgets = aTypes.map((AchievementType aType) {
      final int currentLevel = p.getAchievementLevel(aType.id);
      List<Widget> widgetsType;
      if (aType.id == 1) {
        //just without the divider and spacing above generally
        widgetsType = [
          Text(aType.title, style: Util.subtitleStyle),
        ];
      } else {
        widgetsType = [
          Util.divider(),
          const SizedBox(height: 10),
          Text(aType.title, style: Util.subtitleStyle),
        ];
      }
      for (var i = 0; i < aType.children.length; i++) {
        //cannot use map because the index of the element has to be known
        widgetsType.add(_printAchievement(p, context, aType.children[i], aType.descriptionI(i), currentLevel >= i));
      }
      return widgetsType;
    });
    return widgets.expand((x) => x).toList();
  }

  Widget _printAchievement(
      Secrets pSecrets, BuildContext context, Map<String, dynamic> child, String description, bool completed) {
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
              Text(child["reward"].toString(), style: TextStyle(fontSize: 20, color: color)),
              // const Image(
              //   image: AssetImage('assets/images/trophy.png'),
              //   width: 20,
              //   height: 20,
              // ),
              const SizedBox(width: 5),
              Icon(CustomIcons.trophy, size: 20, color: Colors.amber[800]),
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
              return Util.WarpBody(
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
