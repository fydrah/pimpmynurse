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
  'TPN',
  'PRBC',
  'FFP',
  'PLT',
  'Cryo',
  'Other',
];

const Map<String, String> _defaultSolutions = {
  'Amiodarone': 'D5W',
  'Calcium Chloride': 'D5W',
  'Hydromorphone': 'NS',
  'Lorazepam': 'NS',
  'Magnesium Sulfate': 'D5W',
  'Norepinephrine': 'D5W',
  'Propofol': 'LIPID',
  'Sodium Phosphate': 'D5W',
  'Vasopressyn': 'NS',
};

const List<String> _defaultLossTypes = [
  'AFR',
  'CT',
  'JP',
  'Mediastinal Tube',
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
