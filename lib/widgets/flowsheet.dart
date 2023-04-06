import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/widgets/intake_list.dart';
import 'package:pimpmynurse/widgets/intakes.dart';
import 'package:pimpmynurse/widgets/output_list.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.0,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Ingesta"),
                Tab(text: "Excreta"),
                Tab(text: "Total"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute(
                      builder: (_) => (IntakeList(
                          flowsheet: widget.model, newIntake: newIntake)))),
              Navigator(
                  onGenerateRoute: (_) => MaterialPageRoute(
                      builder: (_) => (OutputList(
                          flowsheet: widget.model, newOutput: newOutput)))),
              Placeholder(),
            ],
          )),
    );
  }
}
