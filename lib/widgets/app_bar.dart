import 'package:flutter/material.dart';
import 'package:pimpmynurse/widgets/flowsheet_list.dart';
import 'package:pimpmynurse/widgets/settings.dart';

class FlowsheetAppBar {
  static AppBar appBar(BuildContext context, {required String title}) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FlowsheetList()));
            }),
        IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            }),
      ],
    );
  }
}
