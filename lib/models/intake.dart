import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/total.dart';
import 'package:pimpmynurse/models/medication.dart';
part 'intake.g.dart';

@HiveType(typeId: 1)
class IntakeModel extends HiveObject {
  IntakeModel({
    required this.hour,
    required this.medications,
  });

  @HiveField(0)
  final int hour;

  @HiveField(1)
  late HiveList<MedicationModel> medications;

  // late TotalModel totalPO;
  // late TotalModel totalCumPO;
  // late TotalModel totalIV;
  // late TotalModel totalCumIV;

  factory IntakeModel.create({required int hour}) => IntakeModel(
      hour: hour, medications: HiveList(Hive.box<IntakeModel>('medications')));

  @override
  String toString() {
    return 'H$hour';
  }
}
