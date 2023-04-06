// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loss_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LossTypeModelAdapter extends TypeAdapter<LossTypeModel> {
  @override
  final int typeId = 3;

  @override
  LossTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LossTypeModel(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LossTypeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LossTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
