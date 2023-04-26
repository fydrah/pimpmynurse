import 'package:hive/hive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
part 'shift.g.dart';

@HiveType(typeId: 8)
enum Shift {
  @HiveField(0)
  day,
  @HiveField(1)
  evening,
  @HiveField(2)
  night,
}

extension ShiftIcons on Shift {
  Icon get icon {
    switch (this) {
      case Shift.day:
        return const Icon(Icons.sunny);
      case Shift.evening:
        return const Icon(CupertinoIcons.sun_dust_fill);
      case Shift.night:
        return const Icon(Icons.bedtime);
      default:
        return const Icon(Icons.question_mark);
    }
  }

  String get name {
    switch (this) {
      case Shift.day:
        return 'Day';
      case Shift.evening:
        return 'Evening';
      case Shift.night:
        return 'Night';
      default:
        return 'ERROR';
    }
  }

  String get shortName {
    switch (this) {
      case Shift.day:
        return 'D';
      case Shift.evening:
        return 'E';
      case Shift.night:
        return 'N';
      default:
        return 'ERROR';
    }
  }
}

class ShiftTypeException implements Exception {
  String msg;

  ShiftTypeException(this.msg);
}
