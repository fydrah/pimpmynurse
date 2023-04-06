import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'medication.g.dart';

@HiveType(typeId: 4)
class MedicationModel extends HiveObject {
  MedicationModel({
    required this.id,
    required this.solutionId,
    required this.quantityMl,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  @protected
  String solutionId;
  @HiveField(2)
  int quantityMl;

  factory MedicationModel.create(
      {required SolutionModel solution, required int quantityMl}) {
    var newMedication = MedicationModel(
        id: const Uuid().v1(),
        solutionId: solution.key,
        quantityMl: quantityMl);
    AppBoxes.medications.put(newMedication.id, newMedication);
    return newMedication;
  }

  SolutionModel getSolution() {
    return AppBoxes.solutions.get(solutionId)!;
  }

  void setSolution(SolutionModel solution) {
    solutionId = solution.id;
    save();
    print(solution.toString());
  }

  void setQt(int quantityMl) {
    this.quantityMl = quantityMl;
    save();
  }

  @override
  String toString() {
    return '$id:${getSolution().medication}:$solutionId:$quantityMl';
  }
}
