import 'package:flutter/material.dart';
import 'package:pimpmynurse/utils/flowsheet/app_bar.dart';
import 'package:pimpmynurse/widgets/flowsheet/setting_flowsheet_limit.dart';
import 'package:pimpmynurse/widgets/flowsheet/setting_export.dart';
import 'package:pimpmynurse/widgets/flowsheet/setting_import.dart';
import 'package:pimpmynurse/widgets/flowsheet/setting_reset.dart';
import 'package:pimpmynurse/widgets/flowsheet/settings_loss_types.dart';
import 'package:pimpmynurse/widgets/flowsheet/settings_solutions.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          FlowsheetAppBar.appBar(context, title: 'Settings', settings: false),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        children: const [
          SettingPaged(
            SettingsSolutions(),
            title: 'Solutions (Medications and Solvents)',
            subtitle: 'Configure available medications',
            leading: ImageIcon(AssetImage('assets/fluid.png')),
          ),
          SettingPaged(SettingsLossTypes(),
              title: 'Loss types',
              subtitle: 'Configure available loss types',
              leading: ImageIcon(AssetImage('assets/nephrology.png'))),
          SettingFlowsheetLimit(),
          SettingImport(),
          SettingExport(),
          SettingReset(),
        ],
      ),
    );
  }
}

class SettingPaged extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget route;

  const SettingPaged(
    this.route, {
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: leading,
        minLeadingWidth: 10,
        title: Text(title),
        subtitle: Text(subtitle),
        tileColor: Theme.of(context).listTileTheme.tileColor,
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => route),
          );
        },
      ),
    );
  }
}
