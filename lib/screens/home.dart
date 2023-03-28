import 'package:flutter/material.dart';
import 'package:pimpmynurse/screens/flowsheethome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appBar(), body: _current);
  }

  late Widget _current = homePageContent();
  late List<Map<String, dynamic>> _pimps = [
    {"name": "Flowsheet", "page": const FlowsheetHome()},
  ];

  void navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  Widget homePageContent() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _pimps.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.blue.shade500,
          child: Center(
              child: TextButton(
            onPressed: () {
              setState(() {
                navigate(context, _pimps[index]['page']);
              });
            },
            child: Text(_pimps[index]['name']),
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
              setState(() {
                _current = homePageContent();
              });
            },
            icon: const Icon(Icons.home)),
        IconButton(
            onPressed: () {
              setState(() {
                _current = const Placeholder();
              });
            },
            icon: const Icon(Icons.info_rounded)),
      ];
}
