import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:pimpmynurse/widgets/app_bar.dart';
import 'package:pimpmynurse/widgets/flowsheet.dart';

class FlowsheetList extends StatefulWidget {
  const FlowsheetList({super.key});

  @override
  State<FlowsheetList> createState() => _FlowsheetListState();
}

class _FlowsheetListState extends State<FlowsheetList> {
  final _textEditController = TextEditingController();

  List<FlowsheetModel> _flowsheetByDate() {
    var items = AppBoxes.flowsheets.values.toList();
    items.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlowsheetAppBar.appBar(context, title: 'Flowsheets'),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              elevation: 8.0,
              child: ListTile(
                onTap: () async {
                  Shift? val = await dialogCreate();
                  if (val != null) {
                    setState(() {
                      FlowsheetModel.create(
                          name: _textEditController.text, shift: val);
                    });
                  }
                },
                title: const Center(child: Icon(Icons.add_circle)),
              )),
          for (var flowsheet in _flowsheetByDate())
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: ListTile(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Flowsheet(model: flowsheet)));
                      });
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.only(right: 2.0),
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  width: 2.0, color: Colors.black38))),
                      child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          bool validated = await showDialog(
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
                          if (validated) {
                            setState(() {
                              flowsheet.delete();
                            });
                          }
                        },
                      ),
                    ),
                    title: Row(
                      children: [
                        const Icon(Icons.personal_injury),
                        Text(flowsheet.name),
                      ],
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text(
                          DateFormat("yyyy-MM-dd kk:mm")
                              .format(flowsheet.createdAt),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const VerticalDivider(),
                        flowsheet.shift.icon,
                        Text(flowsheet.shift.shortName)
                      ],
                    ),
                    trailing: const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Icon(Icons.keyboard_arrow_right),
                    ))),
        ],
      ),
    );
  }

  Future dialogCreate() {
    final formKey = GlobalKey<FormState>();
    return showDialog<Shift>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Shift type'),
                actionsOverflowButtonSpacing: 10.0,
                actions: <Widget>[
                  Form(
                      key: formKey,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _textEditController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a flowsheet name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Flowsheet name',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.refresh_outlined),
                                  onPressed: () {
                                    _textEditController.text =
                                        WordPair.random(safeOnly: true)
                                            .asPascalCase;
                                  }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () => formKey.currentState!.validate()
                                  ? Navigator.pop(context, Shift.day)
                                  : null,
                              child: Row(children: [
                                Shift.day.icon,
                                Text(Shift.day.name),
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () => formKey.currentState!.validate()
                                  ? Navigator.pop(context, Shift.evening)
                                  : null,
                              child: Row(children: [
                                Shift.evening.icon,
                                Text(Shift.evening.name),
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () => formKey.currentState!.validate()
                                  ? Navigator.pop(context, Shift.night)
                                  : null,
                              child: Row(children: [
                                Shift.night.icon,
                                Text(Shift.night.name),
                              ])),
                        ),
                      ]))
                ]));
  }
}
