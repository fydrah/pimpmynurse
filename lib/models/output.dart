import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/total.dart';
import 'package:pimpmynurse/models/medication.dart';
part 'output.g.dart';

@HiveType(typeId: 4)
class OutputModel extends HiveObject {
  OutputModel({
    required this.hour,
    required this.medications,
  });

  @HiveField(0)
  final int hour;

  @HiveField(1)
  late HiveList<MedicationModel> medications; // TODO Change to Loss

  late TotalModel total;
  late TotalModel totalCum;

  factory OutputModel.create({required int hour}) => OutputModel(
      hour: hour, medications: HiveList(Hive.box<OutputModel>('outputs')));

  @override
  String toString() {
    return 'H$hour';
  }
}
