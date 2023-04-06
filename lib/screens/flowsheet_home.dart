import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:pimpmynurse/models/shift.dart';
import 'package:pimpmynurse/widgets/flowsheet.dart';
import 'package:pimpmynurse/widgets/settings.dart';

class FlowsheetHome extends StatefulWidget {
  const FlowsheetHome({super.key});

  @override
  State<FlowsheetHome> createState() => _FlowsheetHomeState();
}

class _FlowsheetHomeState extends State<FlowsheetHome> {
  late Widget current = homeBody();
  bool isHome = true;
  String title = "Flowsheets";
  Box<FlowsheetModel> box = AppBoxes.flowsheets;
  final _textEditController = TextEditingController();

  List<FlowsheetModel> _flowsheetByDate() {
    var items = box.values.toList();
    items.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(context), body: current);
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: isHome
          ? IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : BackButton(onPressed: () {
              setState(() {
                current = homeBody();
              });
            }),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                title = 'Flowsheets';
                current = homeBody();
              });
            },
            icon: const Icon(Icons.list)),
        IconButton(
            onPressed: () {
              setState(() {
                title = 'Settings';
                current = const Settings();
              });
            },
            icon: const Icon(Icons.settings)),
        IconButton(
            onPressed: () async {
              Shift val = await dialogCreate();
              setState(() {
                FlowsheetModel.create(
                    name: _textEditController.text, shift: val);
                current = homeBody();
              });
            },
            icon: const Icon(Icons.add_circle)),
      ],
    );
  }

  Future dialogCreate() {
    _textEditController.text = WordPair.random(safeOnly: true).asPascalCase;
    return showDialog<Shift>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Shift type'),
              actionsOverflowButtonSpacing: 10.0,
              actions: <Widget>[
                TextFormField(
                  controller: _textEditController,
                  decoration: InputDecoration(
                    labelText: 'Flowsheet name',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh_outlined),
                        onPressed: () {
                          _textEditController.text =
                              WordPair.random(safeOnly: true).asPascalCase;
                        }),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, Shift.day),
                    child: Row(children: [
                      Shift.day.icon,
                      Text(Shift.day.name),
                    ])),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, Shift.evening),
                    child: Row(children: [
                      Shift.evening.icon,
                      Text(Shift.evening.name),
                    ])),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, Shift.night),
                    child: Row(children: [
                      Shift.night.icon,
                      Text(Shift.night.name),
                    ])),
              ],
            ));
  }

  Widget homeBody() {
    isHome = true;
    title = 'Flowsheets';
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: box.length,
      itemBuilder: (BuildContext context, int index) {
        var currFlowsheet = _flowsheetByDate()[index];
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: ListTile(
                onTap: () {
                  setState(() {
                    current = Flowsheet(model: currFlowsheet);
                    isHome = false;
                    title = currFlowsheet.name;
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
                          right:
                              BorderSide(width: 2.0, color: Colors.black38))),
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
                          currFlowsheet.delete();
                          current = homeBody();
                        });
                      }
                    },
                  ),
                ),
                title: Text(currFlowsheet.name),
                subtitle: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range),
                    Text(
                      DateFormat("yyyy-MM-dd kk:mm")
                          .format(currFlowsheet.createdAt),
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const VerticalDivider(),
                    currFlowsheet.shift.icon,
                    Text(currFlowsheet.shift.shortName)
                  ],
                ),
                trailing: const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.keyboard_arrow_right),
                )));
      },
    );
  }
}
