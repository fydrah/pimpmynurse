// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intake.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IntakeModelAdapter extends TypeAdapter<IntakeModel> {
  @override
  final int typeId = 1;

  @override
  IntakeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntakeModel(
      hour: fields[0] as int,
      medications: (fields[1] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, IntakeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hour)
      ..writeByte(1)
      ..write(obj.medications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntakeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
