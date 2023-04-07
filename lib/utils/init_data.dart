import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/utils/boxes.dart';

const List<String> _defaultSolvents = [
  '1/2NS',
  'NS',
  'D5W',
  'D5W 1/2NS',
  'D5W NS',
  'D10W',
  'H₂O',
  'FEEDS',
  'LIPID',
  'RL',
];

const Map<String, String> _defaultSolutions = {
  'Amiodarone': 'D5W',
  'Calcium Chloride': 'D5W',
  'Hydromorphome': 'NS',
  'Lorazepam': 'NS',
  'Magnesium Sulfate': 'D5W',
  'Norepinephrine': 'D5W',
  'Propophol': 'LIPID',
  'Sodium Phosphate': 'D5W',
  'Vasopressyn': 'NS',
};

const List<String> _defaultLossTypes = [
  'AFR',
  'CT',
  'JP',
  'NG/OG',
  'Other',
  'Pigtail',
  'RT',
  'Urine',
];

void initSolventsAndSolutions() {
  for (var solventName in _defaultSolvents) {
    if (!AppBoxes.solvents.values.map((e) => e.name).contains(solventName)) {
      SolutionModel.createStandaloneSolvent(solventName: solventName);
    }
  }
  _defaultSolutions.forEach((medication, solventName) {
    if (!AppBoxes.solutions.values.map((e) => e.name()).contains(medication)) {
      SolutionModel.create(
          medication: medication,
          solvent: AppBoxes.solvents.values
              .singleWhere((solvent) => solvent.name == solventName));
    }
  });
}

void initLossTypes() {
  for (var lossTypeName in _defaultLossTypes) {
    if (!AppBoxes.lossTypes.values.map((e) => e.name).contains(lossTypeName)) {
      LossTypeModel.create(name: lossTypeName);
    }
  }
}
