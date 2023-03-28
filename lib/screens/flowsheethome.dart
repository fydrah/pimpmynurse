import 'package:flutter/material.dart';
import 'package:pimpmynurse/widgets/flowsheet.dart';

class FlowsheetHome extends StatelessWidget {
  FlowsheetHome({super.key});

  late Widget current = flowsheetPageContent();
  List<Flowsheet> flowsheetList = [];

  ListView flowsheetPageContent() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: flowsheetList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.blue.shade500,
          child: Center(
              child: TextButton(
            onPressed: () {
              current = flowsheetList[index];
            },
            child: Text(flowsheetList[index].model.date.toString()),
          )),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text('Flowsheet'),
      backgroundColor: Colors.lightBlue.shade300,
      leading: IconButton(
        icon: const Icon(Icons.home),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: appBarActions,
    );
  }

  List<Widget> get appBarActions => [
        IconButton(
            onPressed: () {
              current = flowsheetPageContent();
            },
            icon: const Icon(Icons.list)),
        IconButton(
            onPressed: () {
              current = const Placeholder();
            },
            icon: const Icon(Icons.settings)),
        IconButton(
            onPressed: () {
              var newFlowsheet = Flowsheet();
              flowsheetList.add(newFlowsheet);
              current = newFlowsheet;
            },
            icon: const Icon(Icons.add_circle)),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(context), body: current);
  }
}
