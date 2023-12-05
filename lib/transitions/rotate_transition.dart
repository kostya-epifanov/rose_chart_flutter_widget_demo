import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';

class RotateTransition {
  final List<ChartSectorModel> sectorsData;
  final ChartSectorModel previousTopSector;
  final ChartSectorModel nextTopSector;

  double? transitionValue;

  RotateTransition({
    required this.sectorsData,
    required this.previousTopSector,
    required this.nextTopSector,
  });

  RotateTransition.initial({
    required this.sectorsData,
  })  : previousTopSector = sectorsData.first,
        nextTopSector = sectorsData.first;

  double get calcAngleOffset {
    final int previousIndex = sectorsData.indexOf(previousTopSector);
    final int nextIndex = sectorsData.indexOf(nextTopSector);
    final double sectorAngleRad = 2 * pi / sectorsData.length;

    final deltaIndex = nextIndex - previousIndex;

    int replaceWithOpposite(int deltaIndex) {
      if (deltaIndex.isNegative) {
        return sectorsData.length + deltaIndex;
      }
      return deltaIndex - sectorsData.length;
    }

    final correctedDeltaIndex =
        deltaIndex.abs() > (sectorsData.length / 2) ? replaceWithOpposite(deltaIndex) : deltaIndex;

    final double angleOffsetRad = correctedDeltaIndex * sectorAngleRad;

    final currentAngleRad =
        previousIndex * sectorAngleRad + angleOffsetRad * (transitionValue ?? 1);

    return -currentAngleRad;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RotateTransition &&
        listEquals(other.sectorsData, sectorsData) &&
        other.previousTopSector == previousTopSector &&
        other.nextTopSector == nextTopSector;
  }

  @override
  int get hashCode {
    return sectorsData.hashCode ^ previousTopSector.hashCode ^ nextTopSector.hashCode;
  }
}
