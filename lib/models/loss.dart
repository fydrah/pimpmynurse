import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'loss.g.dart';

@HiveType(typeId: 2)
class LossModel extends HiveObject {
  @protected
  LossModel({
    required this.id,
    required this.lossTypeId,
    required this.quantityMl,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  @protected
  String lossTypeId;
  @HiveField(2)
  int quantityMl;

  factory LossModel.create(
      {required LossTypeModel lossType, required int quantityMl}) {
    var newLoss = LossModel(
        id: const Uuid().v1(),
        lossTypeId: lossType.key,
        quantityMl: quantityMl);
    AppBoxes.losses.put(newLoss.id, newLoss);
    return newLoss;
  }

  void setLossType(LossTypeModel lossType) {
    lossTypeId = lossType.key;
    save();
  }

  LossTypeModel getLossType() {
    return AppBoxes.lossTypes.get(lossTypeId)!;
  }

  void setQt(int quantityMl) {
    this.quantityMl = quantityMl;
    save();
  }

  @override
  String toString() {
    return '$id:${getLossType().name}:$quantityMl';
  }
}
