import 'package:flutter/material.dart';

class SettingImport extends StatefulWidget {
  const SettingImport({super.key});

  @override
  State<SettingImport> createState() => _SettingImportState();
}

class _SettingImportState extends State<SettingImport> {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: const Text('Import'),
          subtitle: const Text('(Coming soon) Import application solutions and loss types from file'),
          tileColor: Theme.of(context).disabledColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: const Icon(Icons.file_download),
          minLeadingWidth: 10,
          onTap: () async {
          },
        ));
  }
}
