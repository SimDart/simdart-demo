import 'package:flutter/material.dart';
import 'package:simdart_demo/production_line/production_line.dart';

class ProductionLineExample extends StatefulWidget {
  const ProductionLineExample({super.key});

  @override
  State<StatefulWidget> createState() => ProductionLineExampleState();
}

class ProductionLineExampleState extends State<ProductionLineExample> {
  bool loading = false;
  int duration = 0;
  ValueNotifier<int> requestedItemCount = ValueNotifier(20);
  ValueNotifier<int> requestInterval = ValueNotifier(5);
  ValueNotifier<int> assemblyDuration = ValueNotifier(5);
  ValueNotifier<int> inspectionDuration = ValueNotifier(5);
  ValueNotifier<int> packagingDuration = ValueNotifier(2);
  ValueNotifier<int> rejectionProbability = ValueNotifier(20);
  SimulationResult? simulationResult;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      RadioGroupWidget(
          title: 'Requested item count:',
          option1: 20,
          option2: 40,
          option3: 60,
          selectedValue: requestedItemCount,
          isEnabled: !loading),
      RadioGroupWidget(
          title: 'Request interval:',
          option1: 5,
          option2: 7,
          option3: 9,
          selectedValue: requestInterval,
          isEnabled: !loading),
      RadioGroupWidget(
          title: 'Assembly duration:',
          option1: 5,
          option2: 10,
          option3: 15,
          selectedValue: assemblyDuration,
          isEnabled: !loading),
      RadioGroupWidget(
          title: 'Inspection duration:',
          option1: 3,
          option2: 5,
          option3: 7,
          selectedValue: inspectionDuration,
          isEnabled: !loading),
      RadioGroupWidget(
          title: 'Rejection probability (%):',
          option1: 10,
          option2: 15,
          option3: 20,
          selectedValue: rejectionProbability,
          isEnabled: !loading),
      RadioGroupWidget(
          title: 'Packaging duration:',
          option1: 2,
          option2: 4,
          option3: 6,
          selectedValue: packagingDuration,
          isEnabled: !loading),
      ElevatedButton(
          onPressed: !loading ? _run : null, child: Text('Run: $duration'))
    ];
    if (loading) {
      children.add(CircularProgressIndicator());
    } else if (simulationResult != null) {
      children.add(ResultGrid(result: simulationResult!));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: children);
  }

  void _run() {
    setState(() {
      loading = true;
    });

    ProductionLine productionLine = ProductionLine(
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
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 4,
      children: <Widget>[
        ResultCard(value: result.assembleCount.toString(), text: 'Assembled'),
        ResultCard(value: result.packagedCount.toString(), text: 'Packaged'),
        ResultCard(value: result.rejectedCount.toString(), text: 'Rejected'),
        ResultCard(
            value: result.duration.toString(), text: 'Total duration (min)'),
        ResultCard(
            value: '${result.rejectionRate.toStringAsFixed(2)}%',
            text: 'Rejection rate'),
        ResultCard(
            value: result.assembleRate.toStringAsFixed(2),
            text: 'Assemble rate (items/min)'),
        ResultCard(
            value: result.packagingRate.toStringAsFixed(2),
            text: 'Packaging rate (items/min)'),
        ResultCard(
            value: result.averageProductionDuration.toStringAsFixed(2),
            text: 'Avg. production duration (min/item)'),
      ],
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({super.key, required this.value, required this.text});

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(children: [Text(value), Text(text)])));
  }
}

class RadioGroupWidget extends StatelessWidget {
  final String title;
  final int option1, option2, option3;
  final ValueNotifier<int> selectedValue;
  final bool isEnabled;

  const RadioGroupWidget({
    super.key,
    required this.title,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.selectedValue,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          spacing: 16,
          children: [
            Text(title),
            ValueListenableBuilder<int>(
              valueListenable: selectedValue,
              builder: (context, value, child) {
                return Row(
                  children: [
                    Radio<int>(
                      value: option1,
                      groupValue: value,
                      onChanged: isEnabled
                          ? (newValue) {
                              if (newValue != null) {
                                selectedValue.value = newValue;
                              }
                            }
                          : null,
                    ),
                    Text(option1.toString()),
                  ],
                );
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: selectedValue,
              builder: (context, value, child) {
                return Row(
                  children: [
                    Radio<int>(
                      value: option2,
                      groupValue: value,
                      onChanged: isEnabled
                          ? (newValue) {
                              if (newValue != null) {
                                selectedValue.value = newValue;
                              }
                            }
                          : null,
                    ),
                    Text(option2.toString()),
                  ],
                );
              },
            ),
            ValueListenableBuilder<int>(
              valueListenable: selectedValue,
              builder: (context, value, child) {
                return Row(
                  children: [
                    Radio<int>(
                      value: option3,
                      groupValue: value,
                      onChanged: isEnabled
                          ? (newValue) {
                              if (newValue != null) {
                                selectedValue.value = newValue;
                              }
                            }
                          : null,
                    ),
                    Text(option3.toString()),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
