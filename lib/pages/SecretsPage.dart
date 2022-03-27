import 'package:flutter/material.dart';
import 'package:ordinary_idle/util/Secrets.dart';
import 'package:ordinary_idle/util/Util.dart';

class SecretsPage extends StatelessWidget {
  final Secrets pSecrets;
  const SecretsPage(this.pSecrets, {Key? key}) : super(key: key);

  static const TextStyle titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Util.WarpBody(
        context: context,
        children: [
          const SizedBox(height: 10),
          const Text("Secrets", style: titleStyle),
          const SizedBox(height: 10),
          ..._printSecrets(pSecrets, context),
        ],
        spacing: 0,
      ),
    );
  }

  List<Widget> _printSecrets(Secrets pSecrets, BuildContext context) {
    var ss = Secrets.secrets;
    var ssh = Secrets.secretHeaders;

    var widgets = ssh.keys.map((int key) {
      if (key == 0) {
        return [
          Text(ssh[key]!["title"]!, style: Util.subtitleStyle),
          Text(ssh[key]!["description"]!),
          ...Secrets.getSecretsByTheme(key)
              .map((int id) => Secrets.getSecretById(id))
              .where((Secret s) => s.type != "hidden")
              .map((Secret s) => _printSecret(pSecrets, context, s)),
        ];
      } else if (pSecrets.unlockedThemes.contains(key)) {
        return [
          Util.divider(),
          const SizedBox(height: 10),
          Text(ssh[key]!["title"]!, style: Util.subtitleStyle),
          Text(ssh[key]!["description"]!),
          ...Secrets.getSecretsByTheme(key)
              .map((int id) => Secrets.getSecretById(id))
              .where((Secret s) => s.type != "hidden")
              .map((Secret s) => _printSecret(pSecrets, context, s)),
        ];
      } else {
        return [
          Util.divider(),
          const SizedBox(height: 10),
          Text("???", style: Util.subtitleStyle),
          Text("You have not unlocked this theme yet."),
          ...Secrets.getSecretsByTheme(key)
              .map((int id) => Secrets.getSecretById(id))
              .where((Secret s) => s.type != "hidden")
              .map((Secret s) => _printSecret(pSecrets, context, s)),
        ];
      }
    });
    return widgets.expand((x) => x).toList();
  }

  Widget _printSecret(Secrets pSecrets, BuildContext context, Secret s) {
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
              Text(
                s.exid,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: pSecrets.prerequisiteMet(s.id)
                    ? Text(
                        s.title,
                        style: TextStyle(
                          fontSize: 20,
                          color: color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    : Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.black38,
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 10),
              Text("+" + s.reward.toString() + "x", style: TextStyle(fontSize: 20, color: color)),
              const SizedBox(width: 10),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
        onTap: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              List<Widget> children;
              if (completed) {
                children = [
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Text(
                        s.title,
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Text(s.description),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ];
              } else {
                children = [
                  const SizedBox(height: 0),
                  pSecrets.prerequisiteMet(s.id)
                      ? Text(
                          s.title,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        )
                      : const Icon(Icons.lock),
                  Text(pSecrets.prerequisiteMet(s.id)
                      ? "LOCKED! Have fun finding it."
                      : "You have not met the prerequisites to find this secret yet. Find other secrets to unlock it."),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ];
              }
              return Util.WarpBody(context: context, children: children);
            },
          );
        });
  }
}
