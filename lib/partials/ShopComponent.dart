import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ordinary_idle/partials/DetailShop.dart';
import 'package:ordinary_idle/partials/HotbarShop.dart';
import 'package:ordinary_idle/util/Money.dart';
import 'package:ordinary_idle/util/Shops.dart';
import 'package:ordinary_idle/util/Util.dart';

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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Util.WarpBody(
                              context: context,
                              children: [
                                ..._printShops("tap", vitals),
                                ..._printShops("idle", vitals),
                              ],
                              spacing: 0,
                            ),
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
      },
    );
  }

  List<Widget> _printShops(String type, Map<String, dynamic> vitals) {
    return [
      const SizedBox(height: 10),
      Text(
        pMoney.shopHeaders[type]!["title"]!,
        style: TextStyle(fontSize: 25),
      ),
      ...pMoney.getShopsByType(type).map((int id) => DetailShop(pMoney, id, vitals)),
    ];
  }
}
