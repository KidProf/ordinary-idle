import 'package:hive/hive.dart';

part 'CurrentSecretV2.g.dart';

@HiveType(typeId: 202)
class CurrentSecretV2 {
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

  CurrentSecretV2({
    required this.sid,
    required this.stage,
    required this.progress,
    required this.total,
    required this.totalStages,
  });
}

//CurrentSecretsV2 model:
// Map<int,CurrentSecretV2>
