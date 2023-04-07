import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';
import 'package:pimpmynurse/widgets/intake.dart';
import 'package:pimpmynurse/widgets/output.dart';
import 'package:pimpmynurse/widgets/total.dart';

class Entry extends StatefulWidget {
  final String title;
  final IntakeModel intake;
  final OutputModel output;

  const Entry(
      {super.key,
      required this.title,
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
          appBar: AppBar(
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Ingesta", icon: Icon(Icons.input)),
                Tab(text: "Excreta", icon: Icon(Icons.output)),
                Tab(text: "Total", icon: Icon(Icons.equalizer)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Intake(model: widget.intake),
              Output(model: widget.output),
              Total(intake: widget.intake, output: widget.output),
            ],
          )),
    );
  }
}
