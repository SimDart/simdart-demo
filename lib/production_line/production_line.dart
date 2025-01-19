import 'dart:math';

import 'package:simdart/simdart.dart';

/// Represents the configuration for a production line simulation algorithm.
class ProductionLine {
  /// Creates an instance of the algorithm configuration.
  ProductionLine({
    required this.requestedItemCount,
    required this.requestInterval,
    required this.assemblyDuration,
    required this.inspectionDuration,
    required this.packagingDuration,
    required this.rejectionProbability,
  });

  final Random _random = Random();

  /// Metrics to track
  int assembledCount = 0;
  int packagedCount = 0;
  int rejectedCount = 0;

  bool get reject => _random.nextDouble() <= rejectionProbability;

  /// The total number of items requested in the simulation.
  final int requestedItemCount;

  /// The time interval between each item being requested (in minutes).
  final int requestInterval;

  /// The production time required to manufacture a single item (in minutes).
  final int assemblyDuration;

  /// The time taken to inspect a single item for quality assurance (in minutes).
  final int inspectionDuration;

  /// The time required to package a single item after inspection (in minutes).
  final int packagingDuration;

  /// The rejection rate during inspection, represented as a percentage (0-100).
  final double rejectionProbability;

  Future<SimulationResult> run() async {
    SimDart sim = SimDart(onTrack: (track) {
      if (track.operation != Operation.resume) {
        print('${track.name}:${track.time}:${track.operation}');
      }
    });

    for (int i = 0; i < requestedItemCount; i++) {
      sim.processAt(
          event: _assemblyItem,
          start: i * requestInterval,
          name: 'assemblyItem');
    }

    await sim.run();

    final int duration = sim.duration!;

    final double rejectionRate =
        assembledCount > 0 ? (rejectedCount / assembledCount) * 100 : 0;

    final double assembleRate = duration > 0 ? assembledCount / duration : 0;
    final double packagingRate = duration > 0 ? packagedCount / duration : 0;

    final double averageProductionDuration =
        assembledCount > 0 ? duration / assembledCount : 0;

    return SimulationResult(
      assembleCount: assembledCount,
      packagedCount: packagedCount,
      rejectedCount: rejectedCount,
      rejectionRate: rejectionRate,
      assembleRate: assembleRate,
      packagingRate: packagingRate,
      averageProductionDuration: averageProductionDuration,
      duration: duration,
    );
  }

  void _assemblyItem(EventContext context) async {
    await context.wait(assemblyDuration);
    assembledCount++;
    context.sim.process(event: _inspectItem, name: 'inspectItem');
  }

  void _inspectItem(EventContext context) async {
    await context.wait(inspectionDuration);
    if (reject) {
      rejectedCount++;
    } else {
      context.sim.process(event: _packItem, name: 'packItem');
    }
  }

  void _packItem(EventContext context) async {
    await context.wait(packagingDuration);
    packagedCount++;
  }
}

/// Represents the result of a production line simulation.
class SimulationResult {
  final int assembleCount;
  final int packagedCount;
  final int rejectedCount;
  final double rejectionRate;
  final double assembleRate;
  final double packagingRate;
  final double averageProductionDuration;
  final int duration;

  SimulationResult({
    required this.assembleCount,
    required this.packagedCount,
    required this.rejectedCount,
    required this.rejectionRate,
    required this.assembleRate,
    required this.packagingRate,
    required this.averageProductionDuration,
    required this.duration,
  });
}
