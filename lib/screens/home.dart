import 'package:flutter/material.dart';
import 'package:pimpmynurse/screens/flowsheet_home.dart';
import 'package:pimpmynurse/widgets/welcome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Widget _current = homePageContent();
  late final List<Map<String, dynamic>> _pimps = [
    {"name": "Flowsheet", "page": const FlowsheetHome()},
  ];

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => Welcome.welcome(context));
    return Scaffold(appBar: appBar(), body: _current);
  }

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
        return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: Card(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(50.0),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  child: Column(
                    children: [
                      Text(_pimps[index]['name']),
                      Divider(color: Theme.of(context).colorScheme.background),
                      const Icon(Icons.gas_meter_sharp),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      navigate(context, _pimps[index]['page']);
                    });
                  },
                ),
              ),
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Pimp my nurse'),
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
