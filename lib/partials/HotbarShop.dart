import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/data/Shops.dart';
import 'package:ordinary_idle/util/Functions.dart';
import 'package:ordinary_idle/util/Styles.dart';

class HotbarShop extends StatelessWidget {
  final Player p;
  final int id;
  late Shop shop;

  HotbarShop(this.p, this.id, {Key? key}) : super(key: key) {
    shop = p.getShopById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: ValueListenableBuilder<Box>(
            valueListenable: Hive.box('purchases').listenable(keys: [id]),
            builder: (context, box, _) {
              return ElevatedButton(
                style: p.possibleByShopId(id) ? Styles.greenRounded : Styles.disabledRounded,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 20),
                          Container(
                            child: Text(
                              shop.title,
                              style: TextStyle(fontSize: 20),
                              overflow: TextOverflow.ellipsis, //wont work, it would just flow out of the screen
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Row(
                        children: [
                          Text(
                            Functions.doubleRepresentation(p.getCostByShopId(id, level: box.get(id))),
                            style: TextStyle(fontSize: 10),
                          ),
                          const Image(
                            image: AssetImage('assets/images/coin.png'),
                            width: 20,
                            height: 20,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  p.purchaseItem(id);
                },
                onLongPress: () {
                  var levelsBought = 0;
                  while (p.purchaseItem(id)) {
                    levelsBought += 1;
                  }
                  if (levelsBought > 0) {
                    p.progressSecret(16, 0);
                  }
                },
              );
            }),
      ),
    );
  }
}

// child: ValueListenableBuilder<Box>(
//               valueListenable: Hive.box('player').listenable(),
//               builder: (ctx, box, _) {
//                 return AppBar(
//                   title: ValueHeader(pCoins: box.get("pCoins")),
//                 );
//               },
//             )
