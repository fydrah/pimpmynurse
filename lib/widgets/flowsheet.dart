import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/widgets/intakes.dart';
import 'package:pimpmynurse/widgets/outputs.dart';

class Flowsheet extends StatefulWidget {
  final FlowsheetModel model;

  const Flowsheet({super.key, required this.model});

  @override
  State<Flowsheet> createState() => _FlowsheetState();
}

class _FlowsheetState extends State<Flowsheet> {
  // @override
  // void initState() {
  //   _openBox().then((value) => setState(() {}));
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   Hive.box('${widget.model.key}_intakes').close();
  //   Hive.box('${widget.model.key}_outputs').close();
  //   super.dispose();
  // }

  // Future _openBox() async {
  //   await Hive.openBox<IntakeModel>('${widget.model.key}_intakes');
  //   await Hive.openBox<IntakeModel>('${widget.model.key}_outputs');
  // }

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
            Intakes(flowsheet: widget.model),
            Outputs(flowsheet: widget.model),
            Placeholder(),
          ],
        ),
      ),
    );
  }
}
