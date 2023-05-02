import 'dart:io';

import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/loss.dart';
import 'package:pimpmynurse/models/medication.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pimpmynurse/utils/boxes.dart';

import '../setup_hive.dart';

void main() async {
  late Directory testDir;

  setUpAll(() => setUpHive().then((value) => testDir = value));

  group('FlowsheetModel', () {
    late FlowsheetModel fsDay;
    late FlowsheetModel fsEvening;
    late FlowsheetModel fsNight;
    setUpAll(() {
      fsDay = FlowsheetModel.create(name: 'testfsday', shift: Shift.day);
      fsEvening =
          FlowsheetModel.create(name: 'testfsevening', shift: Shift.evening);
      fsNight = FlowsheetModel.create(name: 'testfsnight', shift: Shift.night);
    });

    test('New flowsheet should be stored', () {
      expect(fsDay.isInBox, true);
    });

    test('Flowsheets should have correct starting hour', () {
      expect(fsDay.shiftStartingHour, 8);
      expect(fsEvening.shiftStartingHour, 16);
      expect(fsNight.shiftStartingHour, 0);
    });

    test('After creation, entries, intakes and outputs should be empty', () {
      expect(fsDay.entries(), 0);
      expect(fsDay.intakes.length, 0);
      expect(fsDay.outputs.length, 0);
    });

    test('New Intake should be added', () {
      fsDay.newIntake();
      expect(fsDay.entries(), 1);
      expect(fsDay.intakes.length, 1);
    });

    test('New Output should be added', () {
      fsDay.newOutput();
      expect(fsDay.entries(), 1);
      expect(fsDay.outputs.length, 1);
    });

    test('Intakes cumulated sum should be 0 for first entry', () {
      expect(fsDay.intakeCumSumAll(fsDay.intakes.first), 0);
    });

    test('Outputs cumulated sum should be 0 for first entry', () {
      expect(fsDay.outputCumSumAll(fsDay.outputs.first), 0);
    });

    test('Intakes cumulated sum should be 200 for first intake entry', () {
      fsDay.intakes.first.add(MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'NS'),
          quantityMl: 100));
      fsDay.intakes.first.add(MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'D5W'),
          quantityMl: 100));
      expect(fsDay.intakeCumSumAll(fsDay.intakes.first), 200);
    });

    test('Intakes cumulated sum by "NS" should be 100 for first intake entry',
        () {
      expect(
          fsDay.intakeCumSumBy(
              fsDay.intakes.first,
              AppBoxes.solvents.values
                  .firstWhere((element) => element.name == 'NS')),
          100);
    });

    test('Outputs cumulated sum should be 200 for first entry', () {
      fsDay.outputs.first.addLoss(LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'AFR'),
          quantityMl: 100));
      fsDay.outputs.first.addLoss(LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'RT'),
          quantityMl: 100));
      expect(fsDay.outputCumSumAll(fsDay.outputs.first), 200);
    });

    test('Outputs cumulated sum by "AFR" should be 100 for first entry', () {
      expect(
          fsDay.outputCumSumBy(
              fsDay.outputs.first,
              AppBoxes.lossTypes.values
                  .firstWhere((element) => element.name == 'AFR')),
          100);
    });

    test('Intakes solvents list should not contain "D10W" for first entry', () {
      fsDay.newIntake();
      fsDay.intakes.last.add(MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'D10W'),
          quantityMl: 100));
      expect(
          fsDay.getSolventsUntil(fsDay.intakes.first).contains(AppBoxes
              .solvents.values
              .firstWhere((element) => element.name == 'D10W')),
          false);
    });

    test('Intakes solvents list should contain "NS, D5W, D10W" for all entry',
        () {
      expect(
          fsDay.getSolventsUntil(fsDay.intakes.last),
          AppBoxes.solvents.values
              .where((element) => ['NS', 'D5W', 'D10W'].contains(element.name))
              .toList());
    });

    test('Outputs lossTypes list should not contain "Urine" for first entry',
        () {
      fsDay.newOutput();
      fsDay.outputs.last.addLoss(LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'Urine'),
          quantityMl: 100));
      expect(
          fsDay.getLossTypesUntil(fsDay.outputs.first).contains(AppBoxes
              .lossTypes.values
              .firstWhere((element) => element.name == 'Urine')),
          false);
    });

    test('Outputs lossTypes list should contain "AFR, RT, Urine" for all entry',
        () {
      expect(
          fsDay.getLossTypesUntil(fsDay.outputs.last),
          AppBoxes.lossTypes.values
              .where((element) => ['AFR', 'RT', 'Urine'].contains(element.name))
              .toList());
    });
  });

  tearDownAll(() => tearDownHive(testDir));
}
