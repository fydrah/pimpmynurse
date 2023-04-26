import 'package:flutter/material.dart';
import 'package:pimpmynurse/utils/theme_mode_setting.dart';
import 'package:pimpmynurse/widgets/flowsheet/flowsheet_list.dart';
import 'package:pimpmynurse/widgets/welcome.dart';

class Home extends StatefulWidget {
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const Home({super.key, required this.onThemeModeChanged});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> _pimps = [
    {"name": "Flowsheet", "page": const FlowsheetList()},
  ];

  void navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => Welcome.welcome(context));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pimp my nurse'),
          actions: [
            IconButton(
                onPressed: () {
                  // _current = const Placeholder();
                },
                icon: const Icon(Icons.info_rounded)),
            IconButton(
                onPressed: () {
                  setState(() {
                    ThemeModeSetting.change();
                    widget.onThemeModeChanged(ThemeModeSetting.get());
                  });
                },
                icon: ThemeModeSetting.get().iconOpposite),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: _pimps.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 50.0),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
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
                          Divider(
                              color: Theme.of(context).colorScheme.background),
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
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }
}
