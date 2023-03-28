import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';

class Flowsheet extends StatelessWidget {
  final FlowsheetModel model = FlowsheetModel();

  Flowsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CHANGEME"),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Ingesta"),
              Tab(text: "Excreta"),
              Tab(text: "Total"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Placeholder(),
            Placeholder(),
            Placeholder(),
          ],
        ),
      ),
    );
  }
}
