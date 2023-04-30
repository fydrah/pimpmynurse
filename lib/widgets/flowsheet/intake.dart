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
        bottomNavigationBar: bottomBar(context),
        body: Column(
          children: [
            Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              child: ListTile(
                minLeadingWidth: 20,
                leading: const SizedBox(width: 20),
                title: const SizedBox(
                  width: 120,
                  child: Text('Medication',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                        width: 60,
                        child: Text('Qt (ml)',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    SizedBox(width: 30)
                  ],
                ),
              ),
            ),
            Expanded(
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final MedicationModel item =
                          widget.model.medications.removeAt(oldIndex);
                      widget.model.medications.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (var medic in widget.model.medications)
                      medicTile(
                          context,
                          Key(widget.model.medications
                              .indexOf(medic)
                              .toString()),
                          medic),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  BottomAppBar bottomBar(BuildContext context) {
    return BottomAppBar(
        height: 50.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                    headingRowColor: Theme.of(context)
                                        .dataTableTheme
                                        .headingRowColor,
                                    dataRowColor: Theme.of(context)
                                        .dataTableTheme
                                        .dataRowColor,
                                    horizontalMargin: 8.0,
                                    dataRowHeight: 60,
                                    dividerThickness: 2.0,
                                    columns: const [
                                      DataColumn(
                                          label: Text('Medication',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          numeric: true,
                                          label: Text('Qt (ml)',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                    rows: [
                                      for (var type
                                          in widget.model.getSolvents())
                                        DataRow(cells: <DataCell>[
                                          DataCell(
                                            Text("Total ${type.name}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          DataCell(Text(widget.model
                                              .sumBy(type)
                                              .toString())),
                                        ])
                                    ]));
                          });
                    },
                    child: const Text("Ingesta Totals")),
              ),
              const Expanded(flex: 1, child: VerticalDivider()),
              Expanded(
                flex: 10,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.model.add(MedicationModel.create(
                            solution: AppBoxes.solutions.values.first,
                            quantityMl: 0));
                      });
                    },
                    child: const Icon(Icons.add_circle)),
              ),
            ],
          ),
        ));
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

  ListTile medicTile(BuildContext context, Key key, MedicationModel data) {
    final TextEditingController textController =
        TextEditingController(text: data.quantityMl.toString());
    var index = widget.model.medications.indexOf(data);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        key: Key(index.toString()),
        minLeadingWidth: 20,
        leading: ReorderableDragStartListener(
          key: ValueKey<MedicationModel>(data),
          index: index,
          child: const Icon(Icons.unfold_more),
        ),
        title: DropdownSearch<SolutionModel>(
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 55,
              child: TextFormField(
                textAlign: TextAlign.right,
                controller: textController,
                inputFormatters: [NumberTextInputFormatter()],
                keyboardType: TextInputType.number,
                onTap: () {
                  textController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: textController.value.text.length);
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                  width: 30,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      bool? validated = await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Confirm deletion?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Yes')),
                                ],
                              ));
                      if (validated != null && validated) {
                        setState(() {
                          data.delete();
                        });
                      }
                    },
                  )),
            ),
          ],
        ));
  }
}
