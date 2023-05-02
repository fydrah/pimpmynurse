import 'dart:io';

import 'package:pimpmynurse/models/loss.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pimpmynurse/utils/boxes.dart';

import '../setup_hive.dart';

void main() async {
  late Directory testDir;

  setUpAll(() => setUpHive().then((value) => testDir = value));

  group('OutputModel', () {
    late OutputModel output;
    late OutputModel outputCopy;

    setUpAll(() {
      output = OutputModel.create(hour: 0);
    });

    test('New output should be stored', () {
      expect(output.isInBox, true);
    });

    test('New output hour should match provided creation value', () {
      expect(output.hour, 0);
    });

    test('New output loss should be empty', () {
      expect(output.losses.length, 0);
    });

    test('New output copy should match original', () {
      outputCopy = OutputModel.copy(output);
      expect(output.hour, outputCopy.hour);
      expect(output.losses, outputCopy.losses);
    });

    test('New loss should be added to output', () {
      var loss = LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'AFR'),
          quantityMl: 100);
      output.addLoss(loss);
      expect(output.losses.length, 1);
      expect(output.losses.first.key, loss.key);
    });

    test('New output copy should match original', () {
      outputCopy = OutputModel.copy(output);
      expect(output.hour, outputCopy.hour);
      for (var i = 0; i < output.losses.length; i++) {
        expect(output.losses.elementAt(i).getLossType(),
            outputCopy.losses.elementAt(i).getLossType());
        expect(output.losses.elementAt(i).quantityMl,
            outputCopy.losses.elementAt(i).quantityMl);
      }
    });

    test('Output should return valid solvents list', () {
      output.addLoss(LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'AFR'),
          quantityMl: 100));
      output.addLoss(LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'Urine'),
          quantityMl: 100));
      output.addLoss(LossModel.create(
          lossType: AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'RT'),
          quantityMl: 100));
      expect(output.getLossTypes().map((e) => e.name).toList(),
          ['AFR', 'Urine', 'RT']);
    });

    test('Output sum by "AFR" should be 200', () {
      expect(
          output.sumBy(AppBoxes.lossTypes.values
              .firstWhere((element) => element.name == 'AFR')),
          200);
    });

    test('output net sum should be 400', () {
      expect(output.sumAll(), 400);
    });
  });

  tearDownAll(() => tearDownHive(testDir));
}
