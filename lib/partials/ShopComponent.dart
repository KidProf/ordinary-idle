import 'package:flutter/material.dart';
import 'package:ordinary_idle/data/Player.dart';
import 'package:ordinary_idle/partials/DetailShop.dart';
import 'package:ordinary_idle/partials/HotbarShop.dart';
import 'package:ordinary_idle/util/Util.dart';

class ShopComponent extends StatelessWidget {
  final Player p;

  const ShopComponent(this.p, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, dynamic>>(
      valueListenable: p.getVitalsListener,
      builder: (context, vitals, _) {
        return Row(
          children: [
            ...vitals["hotbarShop"].map((int x) => HotbarShop(p, x)),
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
        p.shopHeaders[type]!["title"]!,
        style: TextStyle(fontSize: 25),
      ),
      ...p.getShopsByType(type).map((int id) => DetailShop(p, id, vitals)),
    ];
  }
}
