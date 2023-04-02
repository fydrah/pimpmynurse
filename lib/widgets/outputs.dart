import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/widgets/output.dart';

class Outputs extends StatefulWidget {
  final FlowsheetModel flowsheet;
  const Outputs({super.key, required this.flowsheet});

  @override
  State<Outputs> createState() => _OutputsState();
}

class _OutputsState extends State<Outputs> {
  Box<OutputModel> box = Hive.box('outputs');

  void _newOutput() {
    var newOutput = OutputModel.create(
      hour:
          widget.flowsheet.shiftStartingHour + widget.flowsheet.outputs.length,
    );
    box.add(newOutput);
    widget.flowsheet.outputs.add(newOutput);
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
              for (var output in widget.flowsheet.outputs)
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: TextButton(
                        child: Text(output.toString()),
                        onPressed: () {
                          // TODO
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
                      onPressed: () {
                        setState(() {
                          _newOutput();
                        });
                      })),
            ],
          ),
        ),
      ],
    );
  }
}
