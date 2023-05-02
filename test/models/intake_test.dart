import 'dart:io';

import 'package:pimpmynurse/models/intake.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pimpmynurse/models/medication.dart';
import 'package:pimpmynurse/utils/boxes.dart';

import '../setup_hive.dart';

void main() async {
  late Directory testDir;

  setUpAll(() => setUpHive().then((value) => testDir = value));

  group('IntakeModel', () {
    late IntakeModel intake;
    late IntakeModel intakeCopy;

    setUpAll(() {
      intake = IntakeModel.create(hour: 0);
    });

    test('New intake should be stored', () {
      expect(intake.isInBox, true);
    });

    test('New intake hour should match provided creation value', () {
      expect(intake.hour, 0);
    });

    test('New intake medication should be empty', () {
      expect(intake.medications.length, 0);
    });

    test('New medication should be added to intake', () {
      var medic = MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'NS'),
          quantityMl: 100);
      intake.add(medic);
      expect(intake.medications.length, 1);
      expect(intake.medications.first.key, medic.key);
    });

    test('New intake copy should match original', () {
      intakeCopy = IntakeModel.copy(intake);
      expect(intake.hour, intakeCopy.hour);
      for (var i = 0; i < intake.medications.length; i++) {
        expect(intake.medications.elementAt(i).getSolution(),
            intakeCopy.medications.elementAt(i).getSolution());
        expect(intake.medications.elementAt(i).quantityMl,
            intakeCopy.medications.elementAt(i).quantityMl);
      }
    });

    test('Intake should return valid solvents list', () {
      intake.add(MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'NS'),
          quantityMl: 100));
      intake.add(MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'D5W'),
          quantityMl: 100));
      intake.add(MedicationModel.create(
          solution: AppBoxes.solutions.values
              .firstWhere((element) => element.getSolvent().name == 'D10W'),
          quantityMl: 100));
      expect(intake.getSolvents().map((e) => e.name).toList(),
          ['NS', 'D5W', 'D10W']);
    });

    test('Intake sum by "NS" should be 200', () {
      expect(
          intake.sumBy(AppBoxes.solvents.values
              .firstWhere((element) => element.name == 'NS')),
          200);
    });

    test('Intake net sum should be 400', () {
      expect(intake.sumAll(), 400);
    });
  });

  tearDownAll(() => tearDownHive(testDir));
}
