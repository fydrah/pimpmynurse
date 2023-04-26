// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solvent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SolventModelAdapter extends TypeAdapter<SolventModel> {
  @override
  final int typeId = 7;

  @override
  SolventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SolventModel(
      id: fields[0] as String,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SolventModel obj) {
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
      other is SolventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
