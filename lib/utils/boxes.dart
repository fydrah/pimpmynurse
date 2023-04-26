import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/loss.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/models/medication.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/models/solvent.dart';

class AppBoxes {
  static Box<FlowsheetModel> flowsheets = _getBox<FlowsheetModel>(_flowsheets);
  static Box<IntakeModel> intakes = _getBox<IntakeModel>(_intakes);
  static Box<MedicationModel> medications =
      _getBox<MedicationModel>(_medications);
  static Box<SolutionModel> solutions = _getBox<SolutionModel>(_solutions);
  static Box<SolventModel> solvents = _getBox<SolventModel>(_solvents);
  static Box<OutputModel> outputs = _getBox<OutputModel>(_outputs);
  static Box<LossModel> losses = _getBox<LossModel>(_losses);
  static Box<LossTypeModel> lossTypes = _getBox<LossTypeModel>(_lossTypes);

  static const String _flowsheets = 'flowsheets';
  static const String _intakes = 'intakes';
  static const String _medications = 'medications';
  static const String _outputs = 'outputs';
  static const String _solutions = 'solutions';
  static const String _solvents = 'solvents';
  static const String _losses = 'losses';
  static const String _lossTypes = 'loss_types';

  static Box<E> _getBox<E>(String name) {
    return Hive.box<E>(name);
  }

  static List<Future> openBoxes() {
    return [
      Hive.openBox<FlowsheetModel>(_flowsheets),
      Hive.openBox<IntakeModel>(_intakes),
      Hive.openBox<MedicationModel>(_medications),
      Hive.openBox<SolutionModel>(_solutions),
      Hive.openBox<SolventModel>(_solvents),
      Hive.openBox<OutputModel>(_outputs),
      Hive.openBox<LossModel>(_losses),
      Hive.openBox<LossTypeModel>(_lossTypes),
    ];
  }

  static void registerAdapters() {
    Hive.registerAdapter(FlowsheetModelAdapter());
    Hive.registerAdapter(IntakeModelAdapter());
    Hive.registerAdapter(OutputModelAdapter());
    Hive.registerAdapter(MedicationModelAdapter());
    Hive.registerAdapter(SolutionModelAdapter());
    Hive.registerAdapter(SolventModelAdapter());
    Hive.registerAdapter(LossModelAdapter());
    Hive.registerAdapter(LossTypeModelAdapter());
    Hive.registerAdapter(ShiftAdapter());
  }
}
