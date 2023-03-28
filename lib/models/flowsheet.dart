import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/total.dart';

class FlowsheetHomeModel extends ChangeNotifier {
  final List<FlowsheetModel> flowsheetList = [];
}

class FlowsheetModel {
  final DateTime date = DateTime.now();
  late final ShiftModel shift;
  List<IntakeModel> intakes = [];
  List<OutputModel> outputs = [];
  List<TotalModel> intakeTotals = [];
  List<TotalModel> outputTotals = [];
  int balance = 0;
}
