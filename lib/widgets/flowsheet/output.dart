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
        bottomNavigationBar: BottomAppBar(
            height: 50.0,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.model.addLoss(LossModel.create(
                          lossType: AppBoxes.lossTypes.values.first,
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
              label:
                  Text('Loss', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              numeric: true,
              label: Text('Qt (ml)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          for (var loss in widget.model.losses) lossDataRow(context, loss),
          for (var type in widget.model.getLossTypes())
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

  DataRow lossDataRow(BuildContext context, LossModel data) {
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
            child: DropdownSearch<LossTypeModel>(
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
