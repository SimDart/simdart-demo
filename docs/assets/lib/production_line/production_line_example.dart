import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:simdart/simdart.dart';
import 'package:simdart_demo/production_line/production_line.dart';
import 'package:simdart_demo/production_line/radio_button.dart';
import 'package:simdart_demo/production_line/result_card.dart';
import 'package:simdart_demo/production_line/table_builder.dart';

import 'sparkline_resource.dart';

class ProductionLineExample extends StatefulWidget {
  const ProductionLineExample({super.key});

  @override
  State<StatefulWidget> createState() => ProductionLineExampleState();
}

class ProductionLineExampleState extends State<ProductionLineExample> {
  bool loading = false;

  ValueNotifier<int> packers = ValueNotifier(5);
  ValueNotifier<int> assemblers = ValueNotifier(3);
  ValueNotifier<int> inspectors = ValueNotifier(2);
  ValueNotifier<int> requestedItemCount = ValueNotifier(20);
  ValueNotifier<int> requestInterval = ValueNotifier(1);
  ValueNotifier<int> assemblyDuration = ValueNotifier(5);
  ValueNotifier<int> inspectionDuration = ValueNotifier(2);
  ValueNotifier<int> packagingDuration = ValueNotifier(3);
  ValueNotifier<int> rejectionProbability = ValueNotifier(10);
  SimulationResult? simulationResult;

  EdgeInsets padding = EdgeInsets.fromLTRB(8, 4, 8, 4);

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(fontWeight: FontWeight.bold);
    List<Widget> children = [
      Text("Simulation setup", style: titleStyle),
      _buildForm(context),
      TextButton(
          onPressed: !loading ? _run : null, child: Text('Run the simulation'))
    ];
    if (loading) {
      children.add(CircularProgressIndicator());
    } else if (simulationResult != null) {
      children.add(Text("Simulation result", style: titleStyle));

      children.add(ResultGrid(result: simulationResult!));

      children.add(Wrap(spacing: 32, runSpacing: 16, children: [
        SparklineResource(
            title: 'Assemblers usage',
            simulationResult: simulationResult!,
            resourceId: 'a'),
        SparklineResource(
            title: 'Inspectors usage',
            simulationResult: simulationResult!,
            resourceId: 'i'),
        SparklineResource(
            title: 'Packers usage',
            simulationResult: simulationResult!,
            resourceId: 'p')
      ]));

      children.add(Text("Simulation events", style: titleStyle));

      children.add(EventsViewer(
          key: UniqueKey(),
          tracks: simulationResult!.tracks,
          assemblers: assemblers.value,
          inspectors: inspectors.value,
          packers: packers.value));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: children);
  }

  Widget _buildForm(BuildContext context) {
    TableBuilder tableBuilder = TableBuilder();

    tableBuilder.row()
      ..add(_buildText('Assemblers:'))
      ..add(RadioButton(value: 3, selectedValue: assemblers))
      ..add(RadioButton(value: 5, selectedValue: assemblers))
      ..add(RadioButton(value: 7, selectedValue: assemblers));

    tableBuilder.row()
      ..add(_buildText('Inspectors:'))
      ..add(RadioButton(value: 2, selectedValue: inspectors))
      ..add(RadioButton(value: 5, selectedValue: inspectors))
      ..add(RadioButton(value: 8, selectedValue: inspectors));

    tableBuilder.row()
      ..add(_buildText('Packers:'))
      ..add(RadioButton(value: 5, selectedValue: packers))
      ..add(RadioButton(value: 10, selectedValue: packers))
      ..add(RadioButton(value: 15, selectedValue: packers));

    tableBuilder.row()
      ..add(_buildText('Requested items:'))
      ..add(RadioButton(value: 20, selectedValue: requestedItemCount))
      ..add(RadioButton(value: 40, selectedValue: requestedItemCount))
      ..add(RadioButton(value: 60, selectedValue: requestedItemCount));

    tableBuilder.row()
      ..add(_buildText('Request interval (min):'))
      ..add(RadioButton(value: 1, selectedValue: requestInterval))
      ..add(RadioButton(value: 5, selectedValue: requestInterval))
      ..add(RadioButton(value: 10, selectedValue: requestInterval));

    tableBuilder.row()
      ..add(_buildText('Assembly duration (min):'))
      ..add(RadioButton(value: 5, selectedValue: assemblyDuration))
      ..add(RadioButton(value: 10, selectedValue: assemblyDuration))
      ..add(RadioButton(value: 15, selectedValue: assemblyDuration));

    tableBuilder.row()
      ..add(_buildText('Inspection duration (min):'))
      ..add(RadioButton(value: 2, selectedValue: inspectionDuration))
      ..add(RadioButton(value: 4, selectedValue: inspectionDuration))
      ..add(RadioButton(value: 8, selectedValue: inspectionDuration));

    tableBuilder.row()
      ..add(_buildText('Rejection probability (%):'))
      ..add(RadioButton(value: 10, selectedValue: rejectionProbability))
      ..add(RadioButton(value: 15, selectedValue: rejectionProbability))
      ..add(RadioButton(value: 20, selectedValue: rejectionProbability));

    tableBuilder.row()
      ..add(_buildText('Packaging duration (min):'))
      ..add(RadioButton(value: 3, selectedValue: packagingDuration))
      ..add(RadioButton(value: 6, selectedValue: packagingDuration))
      ..add(RadioButton(value: 9, selectedValue: packagingDuration));

    return tableBuilder.build();
  }

  Widget _buildText(String text) {
    return Text(text);
  }

  void _run() {
    setState(() {
      loading = true;
    });

    ProductionLine productionLine = ProductionLine(
        assemblerCount: assemblers.value,
        inspectorCount: inspectors.value,
        packerCount: packers.value,
        inspectionDuration: inspectionDuration.value,
        packagingDuration: packagingDuration.value,
        assemblyDuration: assemblyDuration.value,
        rejectionProbability: rejectionProbability.value / 100,
        requestedItemCount: requestedItemCount.value,
        requestInterval: requestInterval.value);

    productionLine.run().then((result) {
      setState(() {
        simulationResult = result;
        loading = false;
      });
    });
  }
}

class ResultGrid extends StatelessWidget {
  const ResultGrid({super.key, required this.result});

  final SimulationResult result;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: <Widget>[
        ResultCard(
            value: result.assembleCount.toString(),
            text: 'Assembled',
            icon: Icons.build),
        ResultCard(
            value: result.rejectedCount.toString(),
            text: 'Rejected',
            icon: Icons.block,
            textColor: Colors.red),
        ResultCard(
            value: result.packagedCount.toString(),
            text: 'Packaged',
            icon: Icons.inventory_2_outlined,
            textColor: Colors.green),
        ResultCard(
            value: result.duration.toString(),
            text: 'Total duration (min)',
            icon: Icons.schedule),
        ResultCard(
            value: result.assembleRate.toStringAsFixed(2),
            text: 'Assemble rate (items/min)',
            icon: Icons.trending_up),
        ResultCard(
            value: '${result.rejectionRate.toStringAsFixed(2)}%',
            text: 'Rejection rate',
            icon: Icons.trending_up,
            textColor: Colors.red),
        ResultCard(
            value: result.packagingRate.toStringAsFixed(2),
            text: 'Packaging rate (items/min)',
            icon: Icons.trending_up,
            textColor: Colors.green),
        ResultCard(
            value: result.averageProductionDuration.toStringAsFixed(2),
            text: 'Avg. production duration (min/item)',
            icon: Icons.trending_up),
      ],
    );
  }
}

class EventsViewer extends StatelessWidget {
  const EventsViewer(
      {super.key,
      required this.tracks,
      required this.packers,
      required this.assemblers,
      required this.inspectors});

  final List<SimulationTrack> tracks;
  final int packers;
  final int assemblers;
  final int inspectors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 300, child: _table());
  }

  Widget _table() {
    DaviModel<SimulationTrack> model = DaviModel(
        rows: tracks,
        columns: [
          DaviColumn(
              name: 'Time (min)', cellValue: (params) => params.data.time),
          DaviColumn(
              name: 'Status',
              cellValue: (params) => params.data.status,
              cellTextStyle: (params) => params.data.status == Status.rejected
                  ? TextStyle(color: Colors.red)
                  : null),
          DaviColumn(name: 'Name', cellValue: (params) => params.data.name),
          DaviColumn(
              cellPadding: EdgeInsets.all(4),
              name: 'Assemblers',
              cellBarValue: (params) =>
                  params.data.resourceUsage['a']! / assemblers,
              cellBarStyle: CellBarStyle(
                  barBackground: Colors.transparent,
                  barForeground: (value) {
                    return Color.lerp(
                        Colors.green[200], Colors.red[200], value)!;
                  }),
              cellBarValueStringify: (params) =>
                  '${params.data.resourceUsage['a']!}/$assemblers'),
          DaviColumn(
              cellPadding: EdgeInsets.all(4),
              name: 'Inspectors',
              cellBarValue: (params) =>
                  params.data.resourceUsage['i']! / inspectors,
              cellBarStyle: CellBarStyle(
                  barBackground: Colors.transparent,
                  barForeground: (value) {
                    return Color.lerp(
                        Colors.green[200], Colors.red[200], value)!;
                  }),
              cellBarValueStringify: (params) =>
                  '${params.data.resourceUsage['i']!}/$inspectors'),
          DaviColumn(
              cellPadding: EdgeInsets.all(4),
              name: 'Packers',
              cellBarValue: (params) =>
                  params.data.resourceUsage['p']! / packers,
              cellBarStyle: CellBarStyle(
                  barBackground: Colors.transparent,
                  barForeground: (value) {
                    return Color.lerp(
                        Colors.green[200], Colors.red[200], value)!;
                  }),
              cellBarValueStringify: (params) =>
                  '${params.data.resourceUsage['p']!}/$packers')
        ],
        sortingMode: SortingMode.disabled);
    return Davi(model, columnWidthBehavior: ColumnWidthBehavior.fit);
  }
}
