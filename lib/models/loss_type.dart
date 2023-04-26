import 'package:hive/hive.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'loss_type.g.dart';

@HiveType(typeId: 3)
class LossTypeModel extends HiveObject {
  LossTypeModel({
    required this.id,
    required this.name,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;

  factory LossTypeModel.create({required String name}) {
    var newLossType = LossTypeModel(id: const Uuid().v1(), name: name);
    AppBoxes.lossTypes.put(newLossType.id, newLossType);
    return newLossType;
  }

  void setName(String name) {
    this.name = name;
    save();
  }

  bool isUsed() {
    return AppBoxes.losses.values.any((e) => e.getLossType() == this);
  }

  @override
  String toString() {
    return '$id:$name';
  }
}
