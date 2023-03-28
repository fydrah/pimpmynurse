class ShiftModel {
  final String type;
  final int startingHour;

  ShiftModel({required this.type, required this.startingHour});
}

class DayShiftModel extends ShiftModel {
  DayShiftModel() : super(type: 'D', startingHour: 8);
}

class EveningShiftModel extends ShiftModel {
  EveningShiftModel() : super(type: 'E', startingHour: 16);
}

class NightShiftModel extends ShiftModel {
  NightShiftModel() : super(type: 'N', startingHour: 0);
}
