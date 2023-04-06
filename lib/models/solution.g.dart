// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solution.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SolutionModelAdapter extends TypeAdapter<SolutionModel> {
  @override
  final int typeId = 6;

  @override
  SolutionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SolutionModel(
      id: fields[0] as String,
      medication: fields[1] as String?,
      solventId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SolutionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medication)
      ..writeByte(2)
      ..write(obj.solventId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolutionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
