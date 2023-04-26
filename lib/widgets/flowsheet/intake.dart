import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/medication.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/utils/boxes.dart';

class Intake extends StatefulWidget {
  final IntakeModel model;

  const Intake({super.key, required this.model});

  @override
  State<Intake> createState() => _IntakeState();
}

class _IntakeState extends State<Intake> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.model.add(MedicationModel.create(
                          solution: AppBoxes.solutions.values.first,
                          quantityMl: 0));
                    });
                  },
                  child: const Icon(Icons.add_circle)),
            )),
        body: ListView(children: [
          table(context),
        ]));
  }

  Widget table(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: DataTable(
        headingRowColor: Theme.of(context).dataTableTheme.headingRowColor,
        dataRowColor: Theme.of(context).dataTableTheme.dataRowColor,
        horizontalMargin: 8.0,
        dataRowHeight: 60,
        dividerThickness: 2.0,
        columns: const [
          DataColumn(
              label: Text('Medication',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              numeric: true,
              label: Text('Qt (ml)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          for (var medic in widget.model.medications)
            medicDataRow(context, medic),
          for (var type in widget.model.getSolvents())
            DataRow(cells: <DataCell>[
              DataCell(
                Text("Total ${type.name}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataCell(Text(widget.model.sumBy(type).toString())),
            ])
        ],
      ),
    );
  }

  List<SolutionModel> _solutionsByMedicatedAndName() {
    var medicatedByName = AppBoxes.solutions.values
        .where((element) => element.hasMedication())
        .toList()
      ..sort(((a, b) => a.name().compareTo(b.name())));
    var solventByName = AppBoxes.solutions.values
        .where((element) => !element.hasMedication())
        .toList()
      ..sort(((a, b) => a.name().compareTo(b.name())));

    return medicatedByName + solventByName;
  }

  DataRow medicDataRow(BuildContext context, MedicationModel data) {
    final TextEditingController textController =
        TextEditingController(text: data.quantityMl.toString());
    return DataRow(
      onLongPress: () async {
        bool validated = await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm deletion?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Yes')),
                  ],
                ));
        if (validated) {
          setState(() {
            data.delete();
          });
        }
      },
      cells: [
        DataCell(
          Theme(
            data: ThemeData(
                textTheme:
                    const TextTheme(titleMedium: TextStyle(fontSize: 14))),
            child: DropdownSearch<SolutionModel>(
              // dropdownDecoratorProps: DropDownDecoratorProps(
              //     dropdownSearchDecoration: InputDecoration(
              //         border: OutlineInputBorder(
              //             borderSide:
              //                 BorderSide(width: 20.0, color: Colors.white)))),
              popupProps: const PopupProps.bottomSheet(
                title: Icon(Icons.arrow_drop_down),
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(hintText: 'Search...')),
                fit: FlexFit.loose,
                searchDelay: Duration(seconds: 0),
              ),
              selectedItem: data.getSolution(),
              itemAsString: (item) {
                return item.name();
              },
              items: _solutionsByMedicatedAndName(),
              onChanged: (SolutionModel? value) {
                if (value != null) {
                  setState(() {
                    data.setSolution(value);
                  });
                }
              },
            ),
          ),
        ),
        DataCell(TextFormField(
          textAlign: TextAlign.right,
          controller: textController,
          inputFormatters: [NumberTextInputFormatter()],
          keyboardType: TextInputType.number,
          onTap: () {
            textController.selection = TextSelection(
                baseOffset: 0, extentOffset: textController.value.text.length);
          },
          onFieldSubmitted: (value) {
            setState(() {
              data.setQt(int.tryParse(value) ?? 0);
            });
          },
          onTapOutside: (event) {
            setState(() {
              data.setQt(int.tryParse(textController.text) ?? 0);
            });
          },
        )),
      ],
    );
  }
}