// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flowsheet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlowsheetModelAdapter extends TypeAdapter<FlowsheetModel> {
  @override
  final int typeId = 0;

  @override
  FlowsheetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlowsheetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      shift: fields[2] as dynamic,
      shiftStartingHour: fields[4] as int,
      createdAt: fields[3] as DateTime,
      intakes: (fields[5] as HiveList).castHiveList(),
      outputs: (fields[6] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, FlowsheetModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shift)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.shiftStartingHour)
      ..writeByte(5)
      ..write(obj.intakes)
      ..writeByte(6)
      ..write(obj.outputs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowsheetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
