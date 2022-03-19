import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

class DetailShop extends StatefulWidget {
  final Money pMoney;
  final Shop s;
  late int sid;
  late int level;
  DetailShop(this.pMoney, this.s, {Key? key}) : super(key: key) {
    sid = s.id;
    level = pMoney.getLevelById(sid);
  }

  @override
  State<DetailShop> createState() => _DetailShopState();
}

class _DetailShopState extends State<DetailShop> {
  bool isChecked = false;

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
        valueListenable: Hive.box('purchases').listenable(keys: [widget.sid]),
        builder: (context, box, _) {
          return Card(
            child: ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.s.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Text(
                widget.s.descriptionI(widget.level),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    ),
              ),
              leading: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              trailing: Column(children: [
                  ValueListenableBuilder<Map<String, dynamic>>(
                      valueListenable: widget.pMoney.getVitalsListener,
                      builder: (context, vitals, _) {
                        return ElevatedButton(
                          style: Util.greenRounded,
                          child: Text("BUY"),
                          onPressed: () {
                            print("pressed");
                          },
                        );
                      }),
                ]),
            ),
          );
        });
  }
}
