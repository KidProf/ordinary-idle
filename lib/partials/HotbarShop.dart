import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

class HotbarShop extends StatelessWidget {
  final Money pMoney;
  final int id;
  late Shop shop;

  HotbarShop(this.pMoney, this.id, {Key? key}) : super(key: key) {
    shop = pMoney.getShopById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ValueListenableBuilder<Box>(
            valueListenable: Hive.box('purchases').listenable(keys: [id]),
            builder: (context, box, _) {
              return ValueListenableBuilder<Map<String, dynamic>>(
                valueListenable: pMoney.getVitalsListener,
                builder: (context, vitals, _) {
                  return ElevatedButton(
                    style: pMoney.possibleById(id) ? Util.greenRounded : Util.disabledRounded,
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
                                  overflow: TextOverflow
                                      .ellipsis, //wont work, it would just flow out of the screen
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
                                Util.doubleRepresentation(
                                    pMoney.getCostById(id, level: box.get(id))),
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
                      pMoney.purchaseItem(id);
                    },
                  );
                }
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
