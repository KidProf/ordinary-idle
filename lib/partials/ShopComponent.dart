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
    return Row(
      children: [
        const SizedBox(width: 10),
        HotbarShop(pMoney, 0),
        const SizedBox(width: 10),
        HotbarShop(pMoney, 1),
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
                  child: Column(
                    children: pMoney.shops.map((Shop shop) {
                      return DetailShop(pMoney,shop);
                    }).toList(),
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
  }
}
