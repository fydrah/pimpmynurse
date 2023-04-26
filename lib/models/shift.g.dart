// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShiftAdapter extends TypeAdapter<Shift> {
  @override
  final int typeId = 8;

  @override
  Shift read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Shift.day;
      case 1:
        return Shift.evening;
      case 2:
        return Shift.night;
      default:
        return Shift.day;
    }
  }

  @override
  void write(BinaryWriter writer, Shift obj) {
    switch (obj) {
      case Shift.day:
        writer.writeByte(0);
        break;
      case Shift.evening:
        writer.writeByte(1);
        break;
      case Shift.night:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
