import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/models/intake.dart';
part 'flowsheet.g.dart';

@HiveType(typeId: 0)
class FlowsheetModel extends HiveObject {
  FlowsheetModel({
    required this.name,
    required this.shift,
    required this.shiftStartingHour,
    required this.createdAt,
    required this.intakes,
    required this.outputs,
  });

  @HiveField(0)
  late String name;
  @HiveField(1)
  final String shift;

  // List<TotalModel> intakeTotals = [];
  // List<TotalModel> outputTotals = [];
  // int balance = 0;

  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  int shiftStartingHour;
  @HiveField(4)
  HiveList<IntakeModel> intakes;
  @HiveField(5)
  HiveList<OutputModel> outputs;

  factory FlowsheetModel.create({
    required String name,
    required String shift,
  }) {
    int shiftStartingHour;
    switch (shift) {
      case "D":
        shiftStartingHour = 8;
        break;
      case "E":
        shiftStartingHour = 16;
        break;
      case "N":
        shiftStartingHour = 0;
        break;
      default:
        throw ShiftTypeException(
            "Shift type $shift does not exists ('D','E', 'N')");
    }
    return FlowsheetModel(
        name: name,
        shift: shift,
        shiftStartingHour: shiftStartingHour,
        createdAt: DateTime.now(),
        intakes: HiveList(Hive.box<IntakeModel>('intakes')),
        outputs: HiveList(Hive.box<OutputModel>('outputs')));
  }

  @override
  String toString() {
    return name;
  }
}

class ShiftTypeException implements Exception {
  String msg;

  ShiftTypeException(this.msg);
}
