import 'package:flutter/material.dart';
import 'package:pimpmynurse/models/flowsheet.dart';
import 'package:pimpmynurse/models/intake.dart';
import 'package:pimpmynurse/models/output.dart';

class Total extends StatelessWidget {
  final FlowsheetModel flowsheet;
  final IntakeModel intake;
  final OutputModel output;
  const Total(
      {super.key,
      required this.flowsheet,
      required this.intake,
      required this.output});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const TotalTitle('Balance'),
      TotalValue(intake: intake, output: output, flowsheet: flowsheet),
      const TotalTitle('Ingesta'),
      Card(
          child: TotalTable(intake,
              iterator: flowsheet.getSolventsUntil(intake),
              type: 'intake',
              flowsheet: flowsheet)),
      const TotalTitle('Excreta'),
      Card(
          child: TotalTable(output,
              iterator: flowsheet.getLossTypesUntil(output),
              type: 'output',
              flowsheet: flowsheet)),
    ]);
  }
}

class TotalValue extends StatelessWidget {
  const TotalValue({
    super.key,
    required this.flowsheet,
    required this.intake,
    required this.output,
  });

  final FlowsheetModel flowsheet;
  final IntakeModel intake;
  final OutputModel output;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('${intake.sumAll() - output.sumAll()} ml',
              style: const TextStyle(fontSize: 16)),
          const VerticalDivider(),
          Text(
              '(Cum: ${flowsheet.intakeCumSumAll(intake) - flowsheet.outputCumSumAll(output)} ml)',
              style: const TextStyle(fontSize: 16)),
        ]),
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
  final FlowsheetModel flowsheet;
  final String type;

  const TotalTable(this.data,
      {super.key,
      required this.iterator,
      required this.type,
      required this.flowsheet});

  String _columnName() {
    switch (type) {
      case 'intake':
        return 'Ingesta';
      case 'output':
        return 'Excreta';
      default:
        throw Exception('Valid type is only "intake" or "output"');
    }
  }

  int _cumSumBy(dynamic flowType) {
    switch (type) {
      case 'intake':
        return flowsheet.intakeCumSumBy(data, flowType);
      case 'output':
        return flowsheet.outputCumSumBy(data, flowType);
      default:
        throw Exception('Valid type is only "intake" or "output"');
    }
  }

  int _cumSumAll() {
    switch (type) {
      case 'intake':
        return flowsheet.intakeCumSumAll(data);
      case 'output':
        return flowsheet.outputCumSumAll(data);
      default:
        throw Exception('Valid type is only "intake" or "output"');
    }
  }

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
              label: Text(_columnName(),
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          const DataColumn(
              numeric: true,
              label: Text('Qt (ml)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          const DataColumn(
              numeric: true,
              label: Text('Cum. Qt (ml)',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          for (var flowType in iterator)
            DataRow(cells: <DataCell>[
              DataCell(
                Text("${flowType.name}"),
              ),
              DataCell(Text(data.sumBy(flowType).toString())),
              DataCell(Text(_cumSumBy(flowType).toString())),
            ]),
          DataRow(cells: <DataCell>[
            const DataCell(
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataCell(Text(data.sumAll().toString())),
            DataCell(Text(_cumSumAll().toString())),
          ]),
        ]);
  }
}
