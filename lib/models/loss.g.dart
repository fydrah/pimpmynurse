// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loss.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LossModelAdapter extends TypeAdapter<LossModel> {
  @override
  final int typeId = 2;

  @override
  LossModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LossModel(
      id: fields[0] as String,
      lossTypeId: fields[1] as String,
      quantityMl: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, LossModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lossTypeId)
      ..writeByte(2)
      ..write(obj.quantityMl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LossModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
