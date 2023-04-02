import 'package:hive/hive.dart';
part 'medication.g.dart';

@HiveType(typeId: 3)
class MedicationModel extends HiveObject {
  MedicationModel({
    required this.type,
    required this.quantityMl,
  });

  @HiveField(0)
  String type;
  @HiveField(1)
  int quantityMl;

  factory MedicationModel.create(
          {required String type, required int quantityMl}) =>
      MedicationModel(type: type, quantityMl: quantityMl);

  @override
  String toString() {
    return '$type:$quantityMl';
  }
}
