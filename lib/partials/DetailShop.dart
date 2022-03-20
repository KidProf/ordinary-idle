import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

class DetailShop extends StatelessWidget {
  final Money pMoney;
  final Map<String, dynamic> vitals;
  final int sid;
  late Shop s;
  late int level;

  DetailShop(this.pMoney, this.sid, this.vitals, {Key? key}) : super(key: key) {
    s = pMoney.getShopById(sid);
    level = pMoney.getLevelById(sid);
  }

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
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('purchases').listenable(keys: [sid]),
        builder: (context, box, _) {
          return ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: pMoney.getVitalsListener,
              builder: (context, vitals, _) {
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
                        minHeight: 60,
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
                        pMoney.setHotbarShop(sid, value!);
                      },
                    ),
                    trailing: Container(
                      width: 80,
                      child: Column(children: [
                        ElevatedButton(
                          style: pMoney.possibleById(sid) ? Util.greenRounded : Util.disabledRounded,
                          child: Text("BUY"),
                          onPressed: () {
                            pMoney.purchaseItem(sid);
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              Util.doubleRepresentation(pMoney.getCostById(sid, level: box.get(sid))),
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
                      ]),
                    ),
                  ),
                );
              });
        });
  }
}
