import 'package:flutter/material.dart';
import 'package:pimpmynurse/main.dart';
import 'package:pimpmynurse/utils/boxes.dart';

class SettingReset extends StatefulWidget {
  const SettingReset({super.key});

  @override
  State<SettingReset> createState() => _SettingResetState();
}

class _SettingResetState extends State<SettingReset> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: const Text('Reset'),
          subtitle: const Text('Reset application'),
          tileColor: Theme.of(context).listTileTheme.tileColor,
          leading: const Icon(Icons.warning_rounded),
          minLeadingWidth: 10,
          onTap: () async {
            bool? validated = await showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Confirm reset?'),
                      content: const Text(
                          "This will erase all data within the application"),
                      actions: [
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel')),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Yes')),
                      ],
                    ));
            if (validated != null && validated) {
              await AppBoxes.clearBoxes();
              MainApp.restartApp(context);
            }
          },
        ));
  }
}
