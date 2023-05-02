import 'dart:io';
import 'package:hive/hive.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/utils/flowsheet/init_flowsheet_data.dart';

Future<Directory> setUpHive() async {
  var testDir = await Directory.systemTemp.createTemp();
  Hive.init(testDir.path);

  AppBoxes.registerAdapters();
  await Future.wait(AppBoxes.openBoxes());

  initSolventsAndSolutions();
  initLossTypes();

  return testDir;
}

void tearDownHive(Directory testDir) {
  testDir.delete(recursive: true);
}
