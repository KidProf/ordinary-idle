import 'package:flutter/material.dart';
import 'package:ordinary_idle/util/Secrets.dart';

class SecretsPage extends StatelessWidget {
  final Secrets pSecrets;
  const SecretsPage(this.pSecrets, {Key? key}) : super(key: key);

  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Wrap(
          children: [
            Text("Secrets", style: titleStyle),
            SizedBox(height: 10),
            ..._printSecrets(pSecrets, context),
          ],
          // spacing: 30,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
        ));
  }

  List<Widget> _printSecrets(Secrets pSecrets, BuildContext context) {
    var ss = Secrets.secrets;
    //TODO: group them into different categories based on theme
    return ss.map((Secret s) {
      bool completed = pSecrets.secretCompleted(s.id);
      Color color = completed ? Colors.black : Colors.black38;
      return GestureDetector(
          child: Container(
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                border: Border.all(color: color),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(s.exid, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                  const Spacer(),
                  Text(s.title, style: TextStyle(fontSize: 20, color: color)),
                  const Spacer(),
                  Text("+"+s.reward.toString() + "x", style: TextStyle(fontSize: 20, color: color)),
                  const SizedBox(width: 10),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )),
          onTap: () {
            if (completed) {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 250,
                    color: const Color(0xFFFAFAFA),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(s.title, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 20),
                          Text(s.description),
                          ElevatedButton(
                            child: const Text('Close'),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          });
    }).toList();
  }
}
