import 'package:hive/hive.dart';

part 'PlayerV1.g.dart';

@HiveType(typeId: 100)
class PlayerV1 extends HiveObject {
  @HiveField(100)
  late double pCoins = 1;

  @HiveField(101)
  late double pExpcoins = 0;
}
