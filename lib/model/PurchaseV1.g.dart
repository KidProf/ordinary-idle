// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'PurchaseV1.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class PurchaseV1Adapter extends TypeAdapter<PurchaseV1> {
//   @override
//   final int typeId = 102;

//   @override
//   PurchaseV1 read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return PurchaseV1(
//       pid: fields[100] as int,
//       level: fields[101] as int,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, PurchaseV1 obj) {
//     writer
//       ..writeByte(2)
//       ..writeByte(100)
//       ..write(obj.pid)
//       ..writeByte(101)
//       ..write(obj.level);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is PurchaseV1Adapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
