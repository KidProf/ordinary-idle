import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ordinary_idle/partials/DetailShop.dart';
import 'package:ordinary_idle/partials/HotbarShop.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Shops.dart';

class ShopComponent extends StatelessWidget {
  final Money pMoney;

  const ShopComponent(this.pMoney, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, dynamic>>(
        valueListenable: pMoney.getVitalsListener,
        builder: (context, vitals, _) {
          return Row(
            children: [
              ...vitals["hotbarShop"].map((int x) => HotbarShop(pMoney, x)),
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.amber[800],
                radius: 25,
                child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                            height: 500,
                            child: ListView.builder(
                              // itemExtent: 100,
                              scrollDirection: Axis.vertical,
                              itemCount: pMoney.shops.length,
                              itemBuilder: (BuildContext context, int i) {
                                return DetailShop(pMoney, i, vitals);
                              },
                            ),
                          );
                        },
                      );
                    }),
              ),
              const SizedBox(width: 10),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          );
        });
  }
}
