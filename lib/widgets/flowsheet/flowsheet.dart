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
  static const int _maxEntries = 8;

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
                            if (i != widget.model.entries() - 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Only the latest entry can be removed.')));
                            } else {
                              bool? validated = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
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
                                  widget.model.intakes[i].delete();
                                  widget.model.outputs[i].delete();
                                });
                              }
                            }
                          })),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: widget.model.entries() < _maxEntries
                            ? () async {
                                String? validated = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('New entry'),
                                          content: const Text(
                                              'Duplicate last entry or create an empty one.'),
                                          actionsAlignment:
                                              MainAxisAlignment.center,
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'cancel'),
                                                child: const Text('Cancel')),
                                            const VerticalDivider(),
                                            ElevatedButton(
                                              onPressed:
                                                  widget.model.entries() > 0
                                                      ? () => Navigator.pop(
                                                          context, 'copy')
                                                      : null,
                                              child: const Icon(Icons.copy),
                                            ),
                                            ElevatedButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'new'),
                                                child: const Icon(Icons.add)),
                                          ],
                                        ));
                                switch (validated) {
                                  case 'new':
                                    newIntake();
                                    newOutput();
                                    break;
                                  case 'copy':
                                    setState(() {
                                      widget.model.addIntake(IntakeModel.copy(
                                          widget.model.intakes.last,
                                          hour: widget.model.intakes.last.hour +
                                              1));
                                      widget.model.addOutput(OutputModel.copy(
                                          widget.model.outputs.last,
                                          hour: widget.model.outputs.last.hour +
                                              1));
                                    });
                                    break;
                                  default:
                                }
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Cannot create more than $_maxEntries entries.')));
                              })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
