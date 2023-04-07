import 'package:flutter/material.dart';
import 'package:pimpmynurse/widgets/flowsheet_list.dart';
import 'package:pimpmynurse/widgets/settings.dart';

enum FlowsheetAppBarType {
  home,
  list,
  settings,
}

extension _FlowsheetAppBarType on FlowsheetAppBarType {
  String get name {
    switch (this) {
      case FlowsheetAppBarType.home:
        return 'Home';
      case FlowsheetAppBarType.list:
        return 'Flowsheets';
      case FlowsheetAppBarType.settings:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }

  Icon get iconLeading {
    switch (this) {
      case FlowsheetAppBarType.home:
        return const Icon(Icons.home);
      default:
        return const Icon(Icons.arrow_back);
    }
  }

  Icon get icon {
    switch (this) {
      case FlowsheetAppBarType.home:
        return const Icon(Icons.home);
      case FlowsheetAppBarType.list:
        return const Icon(Icons.list);
      case FlowsheetAppBarType.settings:
        return const Icon(Icons.settings);
      default:
        return const Icon(Icons.error);
    }
  }
}

class FlowsheetAppBar {
  static AppBar appBar(BuildContext context,
      {required FlowsheetAppBarType type, String? title}) {
    return AppBar(
      title: Text(title ?? type.name),
      leading: IconButton(
        icon: type.iconLeading,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
            icon: FlowsheetAppBarType.list.icon,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FlowsheetList()));
            }),
        IconButton(
            icon: FlowsheetAppBarType.settings.icon,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            }),
      ],
    );
  }
}
