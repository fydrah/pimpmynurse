import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:pimpmynurse/utils/flowsheet/flowsheet_limit_setting.dart';
import 'package:pimpmynurse/utils/flowsheet/app_bar.dart';
import 'package:pimpmynurse/widgets/flowsheet/flowsheet.dart';

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
        children: _flowsheetList(context),
      ),
    );
  }

  List<Widget> _flowsheetList(BuildContext context) {
    var items = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ))),
          onPressed: () async {
            if (AppBoxes.flowsheets.length < FlowsheetLimitSetting.get()) {
              Shift? val = await dialogCreate();
              if (val != null) {
                setState(() {
                  FlowsheetModel.create(
                      name: _textEditController.text, shift: val);
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Flowsheet limit exceeded. Update limit, or remove some flowsheets')));
            }
          },
          child: const Icon(Icons.add_circle),
        ),
      ),
    ];

    if (AppBoxes.flowsheets.length == 0) {
      items.add(_flowsheetEmpty());
    } else {
      for (var flowsheet in _flowsheetByDate()) {
        items.add(_flowsheetCard(context, flowsheet));
      }
    }

    return items;
  }

  Widget _flowsheetEmpty() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset('assets/marvin.png'),
            ),
            const Divider(),
            const Text(
              'So empty...',
              style: TextStyle(color: Color.fromARGB(148, 158, 158, 158)),
            )
          ],
        )
      ],
    );
  }

  Card _flowsheetCard(BuildContext context, FlowsheetModel flowsheet) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: ListTile(
            onTap: () {
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Flowsheet(model: flowsheet)));
              });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            leading: Container(
              padding: const EdgeInsets.only(right: 2.0),
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 2.0, color: Colors.black38))),
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
                                  onPressed: () => Navigator.pop(context, true),
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
                const ImageIcon(AssetImage('assets/short_stay.png')),
                Text(flowsheet.name),
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Text(
                  DateFormat("yyyy-MM-dd kk:mm").format(flowsheet.createdAt),
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
            )));
  }

  Future dialogCreate() {
    _textEditController.text = '';
    final formKey = GlobalKey<FormState>();
    return showDialog<Shift>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Shift type'),
                actionsOverflowButtonSpacing: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
