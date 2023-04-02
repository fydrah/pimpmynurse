import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/intake.dart';

class Intake extends StatefulWidget {
  final IntakeModel model;

  const Intake({super.key, required this.model});

  @override
  State<Intake> createState() => _IntakeState();
}

class _IntakeState extends State<Intake> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel')),
      ],
    ));
  }
}
