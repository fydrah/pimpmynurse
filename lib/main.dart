import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/models/medication.dart';
import 'package:pimpmynurse/screens/home.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FlowsheetModelAdapter());
  Hive.registerAdapter(IntakeModelAdapter());
  Hive.registerAdapter(OutputModelAdapter());
  Hive.registerAdapter(MedicationModelAdapter());

  Hive.openBox<FlowsheetModel>('flowsheets');
  Hive.openBox<IntakeModel>('intakes');
  Hive.openBox<OutputModel>('outputs');
  Hive.openBox<MedicationModel>('medications');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pimp my nurse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        appBarTheme: const AppBarTheme(
          color: Colors.cyan,
          //other options
        ),

        //primarySwatch: Colors.blueGrey,
      ),
      home: const Home(),
    );
  }
}
