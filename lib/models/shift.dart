import 'package:flutter/material.dart';

@immutable
class ShiftModel {
  final String type;
  final int startingHour;

  const ShiftModel({required this.type, required this.startingHour});
}

class DayShiftModel extends ShiftModel {
  const DayShiftModel() : super(type: 'D', startingHour: 8);
}

class EveningShiftModel extends ShiftModel {
  const EveningShiftModel() : super(type: 'E', startingHour: 16);
}

class NightShiftModel extends ShiftModel {
  const NightShiftModel() : super(type: 'N', startingHour: 0);
}
