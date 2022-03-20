// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CurrentSecretV1.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentSecretV1Adapter extends TypeAdapter<CurrentSecretV1> {
  @override
  final int typeId = 101;

  @override
  CurrentSecretV1 read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentSecretV1(
      sid: fields[100] as int,
      stage: fields[101] as int,
      progress: fields[102] as int,
      total: fields[203] as num,
      totalStages: fields[104] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentSecretV1 obj) {
    writer
      ..writeByte(5)
      ..writeByte(100)
      ..write(obj.sid)
      ..writeByte(101)
      ..write(obj.stage)
      ..writeByte(102)
      ..write(obj.progress)
      ..writeByte(203)
      ..write(obj.total)
      ..writeByte(104)
      ..write(obj.totalStages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentSecretV1Adapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
