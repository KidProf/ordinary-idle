import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/data/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

class DetailShop extends StatelessWidget {
  final Player p;
  final Map<String, dynamic> vitals;
  final int sid;

  const DetailShop(this.p, this.sid, this.vitals, {Key? key}) : super(key: key);

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    Shop s = p.getShopById(sid);
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('purchases').listenable(keys: [sid]),
        builder: (context, box, _) {
          return ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: p.getVitalsListener,
              builder: (context, vitals, _) {
                int level = p.getLevelById(sid);
                return Card(
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        s.title,
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Container(
                      constraints: BoxConstraints(
                        minHeight: 75,
                      ),
                      child: Text(
                        s.descriptionI(level),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    leading: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: vitals["hotbarShop"].contains(sid),
                      onChanged: (bool? value) {
                        p.setHotbarShop(sid, value!);
                      },
                    ),
                    trailing: Container(
                      width: 80,
                      child: Column(children: [
                        ElevatedButton(
                          style: p.possibleByShopId(sid) ? Util.greenRounded : Util.disabledRounded,
                          child: Text("BUY"),
                          onPressed: () {
                            p.purchaseItem(sid);
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              Util.doubleRepresentation(p.getCostByShopId(sid, level: box.get(sid))),
                              style: TextStyle(fontSize: 10),
                            ),
                            const SizedBox(width: 5),
                            const Image(
                              image: AssetImage('assets/images/coin.png'),
                              width: 20,
                              height: 20,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        Row(
                          children: [
                            Icon(Icons.arrow_upward, color: Colors.black, size: 10),
                            const SizedBox(width: 5),
                            Text("Level "+(p.getLevelById(sid)+1).toString(),style: TextStyle(fontSize: 10),),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        
                      ]),
                    ),
                  ),
                );
              });
        });
  }
}
