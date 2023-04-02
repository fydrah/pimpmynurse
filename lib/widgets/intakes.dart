import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/widgets/intake.dart';

class Intakes extends StatefulWidget {
  final FlowsheetModel flowsheet;
  const Intakes({super.key, required this.flowsheet});

  @override
  State<Intakes> createState() => _IntakesState();
}

class _IntakesState extends State<Intakes> {
  Box<IntakeModel> box = Hive.box('intakes');

  void _newIntake() {
    var newIntake = IntakeModel.create(
      hour:
          widget.flowsheet.shiftStartingHour + widget.flowsheet.intakes.length,
    );
    box.add(newIntake);
    widget.flowsheet.intakes.add(newIntake);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              for (var intake in widget.flowsheet.intakes)
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: TextButton(
                        child: Text(intake.toString()),
                        onPressed: () {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  Intake(model: intake));
                        })),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _newIntake();
                        });
                      })),
            ],
          ),
        ),
      ],
    );
  }
}
