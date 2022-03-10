// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PlayerV1.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerV1Adapter extends TypeAdapter<PlayerV1> {
  @override
  final int typeId = 100;

  @override
  PlayerV1 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerV1()
      ..pCoins = fields[100] as double
      ..pExpcoins = fields[101] as double;
  }

  @override
  void write(BinaryWriter writer, PlayerV1 obj) {
    writer
      ..writeByte(2)
      ..writeByte(100)
      ..write(obj.pCoins)
      ..writeByte(101)
      ..write(obj.pExpcoins);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerV1Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
