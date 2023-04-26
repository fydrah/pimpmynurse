import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/utils/flowsheet/app_bar.dart';
import 'package:pimpmynurse/widgets/flowsheet/entry.dart';

class Flowsheet extends StatefulWidget {
  final FlowsheetModel model;

  const Flowsheet({super.key, required this.model});

  @override
  State<Flowsheet> createState() => _FlowsheetState();
}

class _FlowsheetState extends State<Flowsheet> {
  static const int _maxEntries = 12;

  newIntake() {
    setState(() {
      widget.model.newIntake();
    });
  }

  newOutput() {
    setState(() {
      widget.model.newOutput();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlowsheetAppBar.appBar(context, title: widget.model.name),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                for (var i = 0; i < widget.model.entries(); i++)
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 8.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: TextButton(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${widget.model.intakes[i].hour}h'),
                              const Icon(Icons.access_time_filled)
                            ]),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Entry(
                                  title:
                                      '${widget.model.name} | ${widget.model.shiftStartingHour + i}h',
                                  flowsheet: widget.model,
                                  intake: widget.model.intakes[i],
                                  output: widget.model.outputs[i])));
                        },
                        onLongPress: () async {
                          String? validated = await showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text(
                                        '${widget.model.shiftStartingHour + i}h'),
                                    content: const Text(
                                        'Remove or duplicate entry.'),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'cancel'),
                                          child: const Text('Cancel')),
                                      const VerticalDivider(),
                                      ElevatedButton(
                                          onPressed: () {
                                            if (i !=
                                                widget.model.entries() - 1) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Only the latest entry can be removed.')));
                                            } else {
                                              Navigator.pop(context, 'delete');
                                            }
                                          },
                                          child: const Icon(Icons.delete)),
                                      ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'copy'),
                                          child: const Icon(Icons.copy)),
                                    ],
                                  ));
                          switch (validated) {
                            case 'delete':
                              setState(() {
                                widget.model.intakes[i].delete();
                                widget.model.outputs[i].delete();
                              });
                              break;
                            case 'copy':
                              setState(() {
                                widget.model.addIntake(IntakeModel.copy(
                                    widget.model.intakes[i],
                                    hour: widget.model.intakes[i].hour + 1));
                                widget.model.addOutput(OutputModel.copy(
                                    widget.model.outputs[i],
                                    hour: widget.model.outputs[i].hour + 1));
                              });
                              break;
                            default:
                          }
                        },
                      )),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (widget.model.entries() < _maxEntries) {
                            newIntake();
                            newOutput();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Cannot create more than $_maxEntries entries.')));
                          }
                        })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
