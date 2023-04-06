import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/solvent.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'solution.g.dart';

@HiveType(typeId: 6)
class SolutionModel extends HiveObject {
  SolutionModel({
    required this.id,
    this.medication,
    required this.solventId,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  String? medication;
  @HiveField(2)
  @protected
  String solventId;

  factory SolutionModel.create(
      {String? medication, required SolventModel solvent}) {
    var newSolution = SolutionModel(
        id: const Uuid().v1(), medication: medication, solventId: solvent.key);
    AppBoxes.solutions.put(newSolution.id, newSolution);
    return newSolution;
  }

  factory SolutionModel.createStandaloneSolvent(
          {required String solventName}) =>
      SolutionModel.create(
          solvent: AppBoxes.solvents.values.singleWhere(
              (element) => element.name == solventName,
              orElse: () => SolventModel.create(name: solventName)));

  SolventModel getSolvent() {
    return AppBoxes.solvents.get(solventId)!;
  }

  void setSolvent(SolventModel solvent) {
    solventId = solvent.key;
    save();
  }

  void setMedication(String medication) {
    this.medication = medication;
    save();
  }

  bool hasMedication() => medication != null;

  String name() => medication ?? getSolvent().name;

  @override
  String toString() {
    return '$id:$medication:${getSolvent().name}';
  }
}
