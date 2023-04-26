import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/loss_type.dart';
import 'package:pimpmynurse/utils/boxes.dart';

class SettingsLossTypes extends StatefulWidget {
  const SettingsLossTypes({super.key});

  @override
  State<SettingsLossTypes> createState() => _SettingsLossTypesState();
}

class _SettingsLossTypesState extends State<SettingsLossTypes> {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
