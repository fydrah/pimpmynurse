import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/utils/boxes.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text('Solutions (Medications and Solvents)'),
              subtitle: const Text('Configure available medications'),
              tileColor: Theme.of(context).listTileTheme.tileColor,
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SettingsSolutions()),
                  );
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text('Loss types'),
              subtitle: const Text('Configure available loss types'),
              tileColor: Theme.of(context).listTileTheme.tileColor,
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SettingsLoss()),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsSolutions extends StatefulWidget {
  const SettingsSolutions({super.key});

  @override
  State<SettingsSolutions> createState() => _SettingsSolutionsState();
}

class _SettingsSolutionsState extends State<SettingsSolutions> {
  final String title = 'Solutions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        shrinkWrap: true,
        children: [
          for (var solvent in AppBoxes.solvents.values)
            SettingTile(
              title: solvent.name,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      String? newMedication =
                          await solutionDialog(context, null);
                      if (newMedication != null) {
                        setState(() {
                          SolutionModel.create(
                              medication: newMedication, solvent: solvent);
                        });
                      }
                    },
                    child: const Icon(Icons.add)),
                for (var solution in AppBoxes.solutions.values.where(
                    (e) => e.getSolvent() == solvent && e.hasMedication()))
                  ListTile(
                    title: Text(solution.name()),
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        String? updMedication =
                            await solutionDialog(context, solution);
                        if (updMedication != null) {
                          setState(() {
                            solution.setMedication(updMedication);
                          });
                        }
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: solution.isUsed()
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Currently used by a flowsheet, cannot be removed.')));
                            }
                          : () async {
                              bool validated = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Confirm deletion?'),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancel')),
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Yes')),
                                        ],
                                      ));
                              if (validated) {
                                setState(() {
                                  solution.delete();
                                });
                              }
                            },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<String?> solutionDialog(
      BuildContext context, SolutionModel? existingSolution) {
    var textEditController =
        TextEditingController(text: existingSolution?.medication);
    final formKey = GlobalKey<FormState>();
    return showDialog<String?>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: existingSolution == null
                  ? const Text('New medicated solution')
                  : const Text('Edit medicated solution'),
              actionsOverflowButtonSpacing: 10.0,
              actions: <Widget>[
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: textEditController,
                          decoration: const InputDecoration(
                            labelText: 'Medication name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a medication name';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context, null),
                                  child: const Text('Cancel')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () =>
                                      formKey.currentState!.validate()
                                          ? Navigator.pop(
                                              context, textEditController.text)
                                          : null,
                                  child: Row(children: [
                                    const Icon(Icons.add_circle),
                                    existingSolution == null
                                        ? const Text('Create')
                                        : const Text('Update'),
                                  ])),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ));
  }
}

class SettingsLoss extends StatefulWidget {
  const SettingsLoss({super.key});

  @override
  State<SettingsLoss> createState() => _SettingsLossState();
}

class _SettingsLossState extends State<SettingsLoss> {
  final String title = 'Loss types';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ElevatedButton(
                  onPressed: () async {
                    String? newLossType = await lossTypeDialog(context, null);
                    if (newLossType != null) {
                      setState(() {
                        LossTypeModel.create(name: newLossType);
                      });
                    }
                  },
                  child: const Icon(Icons.add)),
            ),
          ),
          for (var lossType in AppBoxes.lossTypes.values)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                    title: Text(lossType.name),
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        String? updLossType =
                            await lossTypeDialog(context, lossType);
                        if (updLossType != null) {
                          setState(() {
                            lossType.setName(updLossType);
                          });
                        }
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: lossType.isUsed()
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Currently used by a flowsheet, cannot be removed.')));
                            }
                          : () async {
                              bool validated = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text('Confirm deletion?'),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancel')),
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Yes')),
                                        ],
                                      ));
                              if (validated) {
                                setState(() {
                                  lossType.delete();
                                });
                              }
                            },
                    )),
              ),
            ),
        ],
      ),
    );
  }

  Future<String?> lossTypeDialog(
      BuildContext context, LossTypeModel? lossType) {
    var textEditController = TextEditingController(text: lossType?.name);
    final formKey = GlobalKey<FormState>();

    return showDialog<String?>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: lossType == null
                  ? const Text('New loss type')
                  : const Text('Edit loss type'),
              actionsOverflowButtonSpacing: 10.0,
              actions: [
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: textEditController,
                        decoration: const InputDecoration(
                          labelText: 'Loss type',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a loss name';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () => Navigator.pop(context, null),
                                child: const Text('Cancel')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () =>
                                    formKey.currentState!.validate()
                                        ? Navigator.pop(
                                            context, textEditController.text)
                                        : null,
                                child: Row(children: [
                                  const Icon(Icons.add_circle),
                                  lossType == null
                                      ? const Text('Create')
                                      : const Text('Update'),
                                ])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ExpansionTile(
            title: Text(title),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: children),
      ),
    );
  }
}
