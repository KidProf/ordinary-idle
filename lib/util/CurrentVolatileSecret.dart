class CurrentVolatileSecret {
  final int sid;
  final int stage;
  int progress;
  final int total;
  final int totalStages;

  CurrentVolatileSecret({
    required this.sid,
    required this.stage,
    required this.progress,
    required this.total,
    required this.totalStages,
  });
}
