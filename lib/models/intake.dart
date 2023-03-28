import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/total.dart';
import 'package:pimpmynurse/models/medication.dart';

class IntakeModel extends ChangeNotifier {
  late int hour;
  List<MedicationModel> medications = [];
  late TotalModel totalPO;
  late TotalModel totalCumPO;
  late TotalModel totalIV;
  late TotalModel totalCumIV;

  IntakeModel();
}
