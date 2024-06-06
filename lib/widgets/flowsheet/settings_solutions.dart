import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/solution.dart';
import 'package:pimpmynurse/utils/boxes.dart';
import 'package:basic_utils/basic_utils.dart';

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
            SettingSolutionsTile(
              title: solvent.name,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
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
                ),
                for (var solution in AppBoxes.solutions.values.where(
                    (e) => e.getSolvent() == solvent && e.hasMedication()).toList()..sort(((a, b) => a.name().compareTo(b.name()))))
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
                                              context, StringUtils.capitalize(textEditController.text, allWords: true))
                                          : null,
                                  child: existingSolution == null
                                      ? const Icon(Icons.add_circle)
                                      : const Icon(Icons.check_circle)),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ));
  }
}

class SettingSolutionsTile extends StatelessWidget {
  const SettingSolutionsTile({
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
