import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';

class Total extends StatelessWidget {
  final IntakeModel intake;
  final OutputModel output;
  const Total({super.key, required this.intake, required this.output});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const TotalTitle('Balance'),
      TotalValue(intake: intake, output: output),
      const TotalTitle('Ingesta'),
      Card(
          child: TotalTable(intake,
              iterator: intake.getSolvents(), columnName: 'Ingesta')),
      const TotalTitle('Excreta'),
      Card(
          child: TotalTable(output,
              iterator: output.getLossTypes(), columnName: 'Excreta')),
    ]);
  }
}

class TotalValue extends StatelessWidget {
  const TotalValue({
    super.key,
    required this.intake,
    required this.output,
  });

  final IntakeModel intake;
  final OutputModel output;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Center(
          child: Text('${intake.sumAll() - output.sumAll()} ml',
              style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

class TotalTitle extends StatelessWidget {
  final String title;
  const TotalTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Center(
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ));
  }
}

class TotalTable extends StatelessWidget {
  final Set<dynamic> iterator;
  final dynamic data;
  final String columnName;

  const TotalTable(this.data,
      {super.key, required this.iterator, required this.columnName});

  @override
  Widget build(BuildContext context) {
    return DataTable(
        headingRowColor: Theme.of(context).dataTableTheme.headingRowColor,
        dataRowColor: Theme.of(context).dataTableTheme.dataRowColor,
        horizontalMargin: 8.0,
        dataRowHeight: 60,
        dividerThickness: 2.0,
        columns: [
          DataColumn(
              label: Text(columnName,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          const DataColumn(
              numeric: true,
              label: Text('Qt (ml)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          for (var flowType in iterator)
            DataRow(cells: <DataCell>[
              DataCell(
                Text("Total ${flowType.name}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataCell(Text(data.sumBy(flowType).toString())),
            ]),
          DataRow(cells: <DataCell>[
            const DataCell(
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataCell(Text(data.sumAll().toString())),
          ]),
        ]);
  }
}
