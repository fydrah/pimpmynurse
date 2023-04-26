import 'package:flutter/material.dart';
import 'package:pimpmynurse/widgets/flowsheet/settings.dart';

class FlowsheetAppBar {
  static AppBar appBar(BuildContext context,
      {required String title, bool settings = true, TabBar? bottom}) {
    List<Widget> actionList = [];
    if (settings) {
      actionList.add(IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Settings()));
          }));
    }
    return AppBar(title: Text(title), actions: actionList, bottom: bottom);
  }
}
