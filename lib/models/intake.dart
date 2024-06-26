import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/solvent.dart';
import 'package:pimpmynurse/models/medication.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'intake.g.dart';

@HiveType(typeId: 1)
class IntakeModel extends HiveObject {
  IntakeModel({
    required this.id,
    required this.hour,
    required this.medications,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final int hour;
  @HiveField(2)
  HiveList<MedicationModel> medications;

  factory IntakeModel.create({required int hour}) {
    var newIntake = IntakeModel(
        id: const Uuid().v1(),
        hour: hour,
        medications: HiveList(AppBoxes.medications));
    AppBoxes.intakes.put(newIntake.id, newIntake);
    return newIntake;
  }

  factory IntakeModel.copy(IntakeModel intake, {int? hour}) {
    var newIntake = IntakeModel(
        id: const Uuid().v1(),
        hour: hour ?? intake.hour,
        medications: HiveList(AppBoxes.medications));

    AppBoxes.intakes.put(newIntake.id, newIntake);
    for (var medic in intake.medications) {
      newIntake.add(MedicationModel.create(
          solution: medic.getSolution(), quantityMl: medic.quantityMl));
    }
    return newIntake;
  }

  String hourName() => '${hour}h';

  void add(MedicationModel medication) {
    medication.isInBox
        ? null
        : AppBoxes.medications.put(medication.id, medication);
    medications.add(medication);
    save();
  }

  void remove(MedicationModel medication) {
    medications.remove(medication);
    medication.delete();
    save();
  }

  Set<SolventModel> getSolvents() {
    return medications.map((medic) => medic.getSolution().getSolvent()).toSet();
  }

  int sumBy(SolventModel solvent) {
    return medications
        .where((medic) => medic.getSolution().getSolvent() == solvent)
        .map((medic) => medic.quantityMl)
        .fold<int>(0, (prev, next) => prev + next);
  }

  int sumAll() {
    return medications
        .map((medic) => medic.quantityMl)
        .fold<int>(0, (prev, next) => prev + next);
  }

  @override
  Future<void> delete() {
    for (var medication in medications) {
      medication.delete();
    }
    return super.delete();
  }
}
