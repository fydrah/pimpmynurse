import 'package:flutter/material.dart';
import 'package:pimpmynurse/utils/flowsheet/flowsheet_limit_setting.dart';

class SettingFlowsheetLimit extends StatefulWidget {
  const SettingFlowsheetLimit({super.key});

  @override
  State<SettingFlowsheetLimit> createState() => _SettingFlowsheetLimitState();
}

class _SettingFlowsheetLimitState extends State<SettingFlowsheetLimit> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
          title: const Text('Flowsheet limit'),
          subtitle: const Text('Setup flowsheet list limit'),
          tileColor: Theme.of(context).listTileTheme.tileColor,
          leading: const ImageIcon(AssetImage('assets/short_stay.png')),
          minLeadingWidth: 10,
          trailing: Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (!FlowsheetLimitSetting.decrease()) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Limit cannot go below ${FlowsheetLimitSetting.min}, or you need to remove flowsheets before')));
                      }
                    });
                  },
                  icon: const Icon(Icons.remove)),
              Text('${FlowsheetLimitSetting.get()}'),
              IconButton(
                  onPressed: () {
                    setState(() {
                      if (!FlowsheetLimitSetting.increase()) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Limit cannot go over ${FlowsheetLimitSetting.max}')));
                      }
                    });
                  },
                  icon: const Icon(Icons.add))
            ],
          )),
    );
  }
}
