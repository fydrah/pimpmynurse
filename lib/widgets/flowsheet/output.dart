import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:pimpmynurse/models/loss.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/utils/boxes.dart';

class Output extends StatefulWidget {
  final OutputModel model;
  final dynamic setCurrent;

  const Output({super.key, required this.model, this.setCurrent});

  @override
  State<Output> createState() => _OutputState();
}

class _OutputState extends State<Output> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(context),
        body: Column(
          children: [
            const Card(
              margin:
                  EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
              child: ListTile(
                minLeadingWidth: 20,
                leading: SizedBox(width: 20),
                title: SizedBox(
                  width: 120,
                  child: Text('Loss',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                      final LossModel item =
                          widget.model.losses.removeAt(oldIndex);
                      widget.model.losses.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (var loss in widget.model.losses)
                      lossTile(
                          context,
                          Key(widget.model.losses.indexOf(loss).toString()),
                          loss),
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
                                          label: Text('Loss',
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
                                          in widget.model.getLossTypes())
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
                    child: const Text("Excreta Totals")),
              ),
              const Expanded(flex: 1, child: VerticalDivider()),
              Expanded(
                flex: 10,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.model.addLoss(LossModel.create(
                            lossType: AppBoxes.lossTypes.values.first,
                            quantityMl: 0));
                      });
                    },
                    child: const Icon(Icons.add_circle)),
              ),
            ],
          ),
        ));
  }

  ListTile lossTile(BuildContext context, Key key, LossModel data) {
    final TextEditingController textController =
        TextEditingController(text: data.quantityMl.toString());
    var index = widget.model.losses.indexOf(data);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        key: Key(index.toString()),
        minLeadingWidth: 20,
        leading: ReorderableDragStartListener(
          key: ValueKey<LossModel>(data),
          index: index,
          child: const Icon(Icons.unfold_more),
        ),
        title: DropdownSearch<LossTypeModel>(
          popupProps: const PopupProps.bottomSheet(
            title: Icon(Icons.arrow_drop_down),
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
                decoration: InputDecoration(hintText: 'Search...')),
            fit: FlexFit.loose,
            searchDelay: Duration(seconds: 0),
          ),
          selectedItem: data.getLossType(),
          itemAsString: (item) {
            return item.name;
          },
          items: AppBoxes.lossTypes.values.toList(),
          onChanged: (LossTypeModel? value) {
            if (value != null) {
              setState(() {
                data.setLossType(value);
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
