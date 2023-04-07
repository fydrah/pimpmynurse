import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/widgets/entry.dart';

class Flowsheet extends StatefulWidget {
  final FlowsheetModel model;

  const Flowsheet({super.key, required this.model});

  @override
  State<Flowsheet> createState() => _FlowsheetState();
}

class _FlowsheetState extends State<Flowsheet> {
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
    return CustomScrollView(
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
                      child: Text('${widget.model.shiftStartingHour + i}h'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Entry(
                                title:
                                    '${widget.model.name} | ${widget.model.shiftStartingHour + i}h',
                                intake: widget.model.intakes[i],
                                output: widget.model.outputs[i])));
                      },
                      onLongPress: () async {
                        String? validated = await showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                      '${widget.model.shiftStartingHour + i}h'),
                                  content:
                                      const Text('Remove or duplicate entry.'),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'cancel'),
                                        child: const Icon(Icons.cancel)),
                                    const VerticalDivider(),
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'delete'),
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
                        newIntake();
                        newOutput();
                      })),
            ],
          ),
        ),
      ],
    );
    // return DefaultTabController(
    //   length: 3,
    //   child: Scaffold(
    //       appBar: AppBar(
    //         toolbarHeight: 0.0,
    //         automaticallyImplyLeading: false,
    //         bottom: const TabBar(
    //           tabs: [
    //             Tab(text: "Ingesta"),
    //             Tab(text: "Excreta"),
    //             Tab(text: "Total"),
    //           ],
    //         ),
    //       ),
    //       body: TabBarView(
    //         children: [
    //           Navigator(
    //               onGenerateRoute: (_) => MaterialPageRoute(
    //                   builder: (_) => (IntakeList(
    //                       flowsheet: widget.model, newIntake: newIntake)))),
    //           Navigator(
    //               onGenerateRoute: (_) => MaterialPageRoute(
    //                   builder: (_) => (OutputList(
    //                       flowsheet: widget.model, newOutput: newOutput)))),
    //           Placeholder(),
    //         ],
    //       )),
    // );
  }
}
