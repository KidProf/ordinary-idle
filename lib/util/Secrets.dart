import 'package:hive/hive.dart';
import 'package:ordinary_idle/model/CurrentSecretV1.dart';
import 'package:ordinary_idle/util/CurrentVolatileSecret.dart';

class Secrets {
  late Box player;
  late Box currentSecrets;
  late List<int> completedSecrets;
  Map<int, CurrentVolatileSecret> currentVolatileSecrets = {};

  Secrets() {
    player = Hive.box("player");
    currentSecrets = Hive.box("currentSecrets");
    completedSecrets = player.get("completedSecrets", defaultValue: <int>[]);
  }

  static final secrets = [
    Secret(
        id: 1,
        exid: "0.1",
        prerequisites: [],
        title: "Welcome",
        description:
            "Congratulations on discovering your first secret. I would say this is the most important secret, as it unlocks the secrets page and your ability to find other secrets.",
        progressComponent: [
          {
            "total": 20,
            "volatile": true,
          }
        ]),
    Secret(
      id: 2,
      exid: "1.1",
      prerequisites: [1],
      title: "Tap outeide the cookie",
      description:
          "As the cookie will move around and even change in size, I think taking taps outside the cookie into account is a good idea.",
      progressComponent: [],
    ),
    Secret(
      id: 3,
      exid: "1.2",
      prerequisites: [1],
      title: "Where did the cookie go?",
      description: "Swipe the cookie up until it disappears from the screen.",
      progressComponent: [],
    )
  ];

  Secret getSecretById(int id) {
    return secrets.where((s) => s.id == id).first;
  }

  void progressSecret(int id, int stage) {
    if (completedSecrets.contains(id)) {
      return; //completed already, so no need tracking
    } else if (currentSecrets.containsKey(id)) {
      final CurrentSecretV1 c = currentSecrets.get(id);
      if (c.stage == stage) {
        //no progression if wrong stage, the ! is for null checking, which I think doesnt needed because we are sure it contains the key
        c.progress += 1;
        currentSecrets.put(id, c);
      }
      if (c.progress == c.total) {
        currentVolatileSecrets.remove(id);
        if(c.stage+1==c.totalStages){
          _completeSecret(id);
        }else{
          _initNewSecret(id, c.stage + 1);
        }
        
      }
    } else if (currentVolatileSecrets.containsKey(id)) {
      final CurrentVolatileSecret cv = currentVolatileSecrets[id]!;
      if (cv.stage == stage) {
        //no progression if wrong stage, the ! is for null checking, which I think doesnt needed because we are sure it contains the key
        cv.progress += 1;
      }
      if (cv.progress == cv.total) {
        currentVolatileSecrets.remove(id);
        if(cv.stage+1==cv.totalStages){
          _completeSecret(id);
        }else{
          _initNewSecret(id, cv.stage + 1);
        }
      }
      
    } else {
      _initNewSecret(id, 0);
    }
  }

  void _initNewSecret(int id, int stage) {
    final s = getSecretById(id);
    final sp = s.progressComponent[stage];
    if (sp["volatile"]) {
      currentVolatileSecrets[id] = CurrentVolatileSecret(
        sid: id,
        stage: stage,
        progress: 0,
        total: sp["total"],
        totalStages: s.progressComponent.length,
      );
    } else {
      currentSecrets.put(
          id,
          CurrentSecretV1(
            sid: id,
            stage: 0,
            progress: stage,
            total: sp["total"],
            totalStages: s.progressComponent.length,
          ));
    }
  }

  void _completeSecret(int id){
    //TODO: better side effects
    currentSecrets.add(id);
    player.put("currentSecrets",currentSecrets);
  }
}

class Secret {
  final int id;
  final String exid;
  final List<int> prerequisites;
  final String title;
  final String description;
  final List<Map> progressComponent;

  Secret({
    required this.id,
    required this.exid,
    required this.title,
    required this.prerequisites,
    required this.description,
    required this.progressComponent,
  });
}
