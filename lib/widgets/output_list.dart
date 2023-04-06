import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/widgets/output.dart';

class OutputList extends StatelessWidget {
  final FlowsheetModel flowsheet;
  final dynamic newOutput;
  const OutputList({super.key, required this.flowsheet, this.newOutput});

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
              for (var output in flowsheet.outputs)
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: TextButton(
                        child: Text(output.hourName()),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Output(model: output)));
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
                        newOutput();
                      })),
            ],
          ),
        ),
      ],
    );
  }
}
