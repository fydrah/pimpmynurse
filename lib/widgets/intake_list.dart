import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/widgets/intake.dart';

class IntakeList extends StatelessWidget {
  final FlowsheetModel flowsheet;
  final dynamic newIntake;

  const IntakeList({super.key, required this.flowsheet, this.newIntake});

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
              for (var intake in flowsheet.intakes)
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: TextButton(
                        child: Text(intake.hourName()),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Intake(model: intake)));
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
                        newIntake();
                      })),
            ],
          ),
        ),
      ],
    );
  }
}
