// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutputModelAdapter extends TypeAdapter<OutputModel> {
  @override
  final int typeId = 5;

  @override
  OutputModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutputModel(
      id: fields[0] as String,
      hour: fields[1] as int,
      losses: (fields[2] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, OutputModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hour)
      ..writeByte(2)
      ..write(obj.losses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutputModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
