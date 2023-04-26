import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/utils/flowsheet/app_bar.dart';
import 'package:pimpmynurse/widgets/flowsheet/intake.dart';
import 'package:pimpmynurse/widgets/flowsheet/output.dart';
import 'package:pimpmynurse/widgets/flowsheet/total.dart';

class Entry extends StatefulWidget {
  final String title;
  final FlowsheetModel flowsheet;
  final IntakeModel intake;
  final OutputModel output;

  const Entry(
      {super.key,
      required this.title,
      required this.flowsheet,
      required this.intake,
      required this.output});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: FlowsheetAppBar.appBar(
            context,
            title: widget.title,
            bottom: const TabBar(
              tabs: [
                Tab(
                    text: "Ingesta",
                    icon: ImageIcon(AssetImage('assets/inpatient.png'))),
                Tab(
                    text: "Excreta",
                    icon: ImageIcon(AssetImage('assets/outpatient.png'))),
                Tab(
                    text: "Total",
                    icon: ImageIcon(AssetImage('assets/fluid_balance.png'))),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Intake(model: widget.intake),
              Output(model: widget.output),
              Total(
                  flowsheet: widget.flowsheet,
                  intake: widget.intake,
                  output: widget.output),
            ],
          )),
    );
  }
}
