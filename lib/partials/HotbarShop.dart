import 'package:flutter/material.dart';

class HotbarShop extends StatelessWidget {
  final int id;
  const HotbarShop(this.id, {Key? key}) : super(key: key);

  static final ButtonStyle greenRounded = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: Colors.green),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: greenRounded,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 12,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_upward, size: 20),
                    Text(
                      "Tap",
                      style: TextStyle(fontSize: 20),
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
                    Text("12", style: TextStyle(fontSize: 10)),
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
            print("Hello world");
          },
        ),
      ),
    );
  }
}
