import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/widgets/flowsheet.dart';

class FlowsheetHome extends StatefulWidget {
  const FlowsheetHome({super.key});

  @override
  State<FlowsheetHome> createState() => _FlowsheetHomeState();
}

class _FlowsheetHomeState extends State<FlowsheetHome> {
  late Widget current = homeBody();
  bool isHome = true;
  String title = "Flowsheets";
  Box<FlowsheetModel> box = Hive.box<FlowsheetModel>('flowsheets');
  final _textEditController = TextEditingController();

  void _newFlowsheet(String shift, String name) {
    FlowsheetModel newFs = FlowsheetModel.create(name: name, shift: shift);
    box.add(newFs);
  }

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
                current = homeBody();
              });
            },
            icon: const Icon(Icons.list)),
        IconButton(
            onPressed: () {
              setState(() {
                current = const Placeholder();
              });
            },
            icon: const Icon(Icons.settings)),
        IconButton(
            onPressed: () async {
              var val = await dialogCreate();
              if (val != null) {
                setState(() {
                  _newFlowsheet(val, _textEditController.text);
                  current = homeBody();
                });
              }
            },
            icon: const Icon(Icons.add_circle)),
      ],
    );
  }

  Icon _shift2Icon(String shift) {
    switch (shift) {
      case 'D':
        return const Icon(Icons.sunny);
      case 'E':
        return const Icon(CupertinoIcons.sun_dust_fill);
      case 'N':
        return const Icon(Icons.bedtime);
      default:
        return const Icon(Icons.question_mark);
    }
  }

  Future dialogCreate() {
    _textEditController.text = WordPair.random(safeOnly: true).asPascalCase;
    return showDialog<String>(
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
                    onPressed: () => Navigator.pop(context, 'D'),
                    child: Row(children: [
                      _shift2Icon('D'),
                      const Text('Day'),
                    ])),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'E'),
                    child: Row(children: [
                      _shift2Icon('E'),
                      const Text('Evening'),
                    ])),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'N'),
                    child: Row(children: [
                      _shift2Icon('N'),
                      const Text('Night'),
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // tileColor: Colors.lightBlueAccent,
                leading: Container(
                  padding: const EdgeInsets.only(right: 2.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 2.0, color: Colors.black38))),
                  child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          currFlowsheet.delete();
                          current = homeBody();
                        });
                      }),
                ),
                title: Text(currFlowsheet.name),
                subtitle: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range),
                    Text(
                      DateFormat("yyyy-MM-dd kk:mm")
                          .format(currFlowsheet.createdAt),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const VerticalDivider(),
                    _shift2Icon(currFlowsheet.shift),
                    Text(currFlowsheet.shift)
                  ],
                ),
                trailing: IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: const Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    setState(() {
                      current = Flowsheet(model: currFlowsheet);
                      isHome = false;
                      title = currFlowsheet.name;
                    });
                  },
                )));
      },
    );
  }
}
