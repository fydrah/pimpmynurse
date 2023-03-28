import 'package:flutter/material.dart';
import 'package:pimpmynurse/screens/flowsheet.dart';

class Home extends StatelessWidget {
  Home({super.key});

  late Widget current = homePageContent();
  List<Map<String, dynamic>> pimps = [
    {"name": "Flowsheet", "page": FlowsheetHome()},
  ];

  void navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget homePageContent() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: pimps.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.blue.shade500,
          child: Center(
              child: TextButton(
            onPressed: () {
              navigate(context, pimps[index]['page']);
            },
            child: Text(pimps[index]['name']),
          )),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Pimp my nurse'),
      backgroundColor: Colors.lightBlue.shade300,
      actions: appBarActions,
    );
  }

  List<Widget> get appBarActions => [
        IconButton(
            onPressed: () {
              current = homePageContent();
            },
            icon: const Icon(Icons.home)),
        IconButton(
            onPressed: () {
              current = const Placeholder();
            },
            icon: const Icon(Icons.info_rounded)),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: current);
  }
}
