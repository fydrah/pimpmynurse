import 'package:pimpmynurse/models/total.dart';
import 'package:pimpmynurse/models/loss.dart';

class OutputModel {
  late int hour;
  List<LossModel> medications = [];
  late TotalModel total;
  late TotalModel totalCum;

  OutputModel();
}
