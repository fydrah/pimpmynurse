import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:uuid/uuid.dart';
part 'flowsheet.g.dart';

@HiveType(typeId: 0)
class FlowsheetModel extends HiveObject {
  FlowsheetModel({
    required this.id,
    required this.name,
    required this.shift,
    required this.shiftStartingHour,
    required this.createdAt,
    required this.intakes,
    required this.outputs,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  final Shift shift;

  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  int shiftStartingHour;
  @HiveField(5)
  HiveList<IntakeModel> intakes;
  @HiveField(6)
  HiveList<OutputModel> outputs;

  factory FlowsheetModel.create({
    required String name,
    required Shift shift,
  }) {
    int shiftStartingHour;
    switch (shift) {
      case Shift.day:
        shiftStartingHour = 8;
        break;
      case Shift.evening:
        shiftStartingHour = 16;
        break;
      case Shift.night:
        shiftStartingHour = 0;
        break;
      default:
        throw ShiftTypeException(
            "Shift type $shift does not exists ('D','E', 'N')");
    }

    var newFlowsheet = FlowsheetModel(
      id: const Uuid().v1(),
      name: name,
      shift: shift,
      shiftStartingHour: shiftStartingHour,
      createdAt: DateTime.now(),
      intakes: HiveList(AppBoxes.intakes),
      outputs: HiveList(AppBoxes.outputs),
    );
    AppBoxes.flowsheets.put(newFlowsheet.id, newFlowsheet);
    return newFlowsheet;
  }

  int entries() {
    return intakes.length >= outputs.length ? intakes.length : outputs.length;
  }

  void newIntake() {
    var intake = IntakeModel.create(
      hour: shiftStartingHour + intakes.length,
    );
    AppBoxes.intakes.put(intake.id, intake);
    addIntake(intake);
  }

  void addIntake(IntakeModel intake) {
    intakes.add(intake);
    save();
  }

  void removeIntake(IntakeModel intake) {
    intakes.remove(intake);
    save();
  }

  void newOutput() {
    var output = OutputModel.create(
      hour: shiftStartingHour + outputs.length,
    );
    AppBoxes.outputs.put(output.id, output);
    addOutput(output);
  }

  void addOutput(OutputModel output) {
    outputs.add(output);
    save();
  }

  void removeOutput(OutputModel output) {
    outputs.remove(output);
    save();
  }

  @override
  Future<void> delete() {
    intakes.deleteAllFromHive();
    outputs.deleteAllFromHive();
    return super.delete();
  }
}
