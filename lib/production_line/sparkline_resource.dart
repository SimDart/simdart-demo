

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/widgets.dart';
import 'package:simdart/simdart.dart';
import 'package:simdart_demo/production_line/production_line.dart';

class SparklineResource extends StatelessWidget {



  const SparklineResource({super.key,required this.title,
    required this.simulationResult, required this.resourceId});

  final SimulationResult simulationResult;
  final String resourceId;
  final String title;

  @override
  Widget build(BuildContext context) {
    List<double> data = [];
    for(SimulationTrack track in simulationResult.tracks) {
      int usage = track.resourceUsage[resourceId]!;
      data.add(usage.toDouble());
    }
    return SizedBox(
        width: 300,
        child: AspectRatio(
        aspectRatio: 1.5, child: Column(spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(title),
      Expanded(child: Sparkline(
      gridLinesEnable: true,
      data: data
    ))])));

  }

}