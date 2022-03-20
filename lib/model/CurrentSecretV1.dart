import 'package:hive/hive.dart';

part 'CurrentSecretV1.g.dart';

@HiveType(typeId: 101)
class CurrentSecretV1 {
  @HiveField(100)
  final int sid;

  @HiveField(101)
  final int stage;

  @HiveField(102)
  int progress;

  @HiveField(203)
  final num total;

  @HiveField(104)
  final int totalStages;

  CurrentSecretV1({
    required this.sid,
    required this.stage,
    required this.progress,
    required this.total,
    required this.totalStages,
  });
}

//CurrentSecretsV1 model:
// Map<int,CurrentSecretV1>
