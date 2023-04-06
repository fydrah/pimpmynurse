import 'package:hive/hive.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'solvent.g.dart';

@HiveType(typeId: 7)
class SolventModel extends HiveObject {
  SolventModel({
    required this.id,
    required this.name,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;

  factory SolventModel.create({required String name}) {
    var newSolvent = SolventModel(id: const Uuid().v1(), name: name);
    AppBoxes.solvents.put(newSolvent.id, newSolvent);
    return newSolvent;
  }

  void setName(String name) {
    this.name = name;
    save();
  }

  @override
  String toString() {
    return '$id:$name';
  }
}
