import 'package:flutter/material.dart';

class SettingExport extends StatefulWidget {
  const SettingExport({super.key});

  @override
  State<SettingExport> createState() => _SettingExportState();
}

class _SettingExportState extends State<SettingExport> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: const Text('Export'),
          subtitle: const Text('(Coming soon) Export application solutions and loss types to file'),
          tileColor: Theme.of(context).disabledColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: const Icon(Icons.upload),
          minLeadingWidth: 10,
          onTap: () async {
          },
        ));
  }
}
