import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/loss.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:uuid/uuid.dart';
part 'output.g.dart';

@HiveType(typeId: 5)
class OutputModel extends HiveObject {
  OutputModel({
    required this.id,
    required this.hour,
    required this.losses,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final int hour;
  @HiveField(2)
  HiveList<LossModel> losses;

  factory OutputModel.create({required int hour}) {
    var newOutput = OutputModel(
        id: const Uuid().v1(), hour: hour, losses: HiveList(AppBoxes.losses));
    AppBoxes.outputs.put(newOutput.id, newOutput);
    return newOutput;
  }

  factory OutputModel.copy(OutputModel output, {int? hour}) {
    var newOutput = OutputModel(
        id: const Uuid().v1(),
        hour: hour ?? output.hour,
        losses: HiveList(AppBoxes.losses));

    AppBoxes.outputs.put(newOutput.id, newOutput);
    for (var loss in output.losses) {
      newOutput.addLoss(LossModel.create(
          lossType: loss.getLossType(), quantityMl: loss.quantityMl));
    }
    return newOutput;
  }

  String hourName() => '${hour}h';

  void addLoss(LossModel loss) {
    losses.add(loss);
    save();
  }

  void removeLoss(LossModel loss) {
    losses.remove(loss);
    loss.delete();
    save();
  }

  Set<LossTypeModel> getLossTypes() {
    return losses.map((loss) => loss.getLossType()).toSet();
  }

  int sumBy(LossTypeModel lossType) {
    return losses
        .where((loss) => loss.getLossType() == lossType)
        .map((loss) => loss.quantityMl)
        .fold<int>(0, (prev, next) => prev + next);
  }

  int sumAll() {
    return losses
        .map((loss) => loss.quantityMl)
        .fold<int>(0, (prev, next) => prev + next);
  }

  @override
  Future<void> delete() {
    for (var loss in losses) {
      loss.delete();
    }
    return super.delete();
  }
}
