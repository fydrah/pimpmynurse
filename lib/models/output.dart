import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/loss.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/models/total.dart';
import 'package:pimpmynurse/models/medication.dart';
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

  late TotalModel total;
  late TotalModel totalCum;

  factory OutputModel.create({required int hour}) {
    var newOutput = OutputModel(
        id: const Uuid().v1(), hour: hour, losses: HiveList(AppBoxes.losses));
    AppBoxes.outputs.put(newOutput.id, newOutput);
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

  int sumByLossType(LossTypeModel lossType) {
    return losses
        .where((loss) => loss.getLossType() == lossType)
        .map((loss) => loss.quantityMl)
        .fold<int>(0, (prev, next) => prev + next);
  }

  @override
  Future<void> delete() {
    losses.deleteAllFromHive();
    return super.delete();
  }
}
