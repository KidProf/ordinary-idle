import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ordinary_idle/partials/HotbarShop.dart';
import 'package:ordinary_idle/util/Money.dart';

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
              Fluttertoast.showToast(
                  msg: "I haven't done this page",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ),
        const SizedBox(width: 10),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    );
  }
}
