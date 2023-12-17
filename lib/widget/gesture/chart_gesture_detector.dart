import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/widget/gesture/measure_size_widget.dart';

class ChartGestureDetector extends StatefulWidget {
  final Widget chart;
  final List<ChartSectorModel> dataList;
  final double centralCircleRadiusMod;
  final double offsetForLabels;
  final ChartTransition chartTransition;
  final double chartTransitionValue;
  final RotateTransition rotateTransition;
  final void Function(ChartSectorModel) onTapSector;
  final void Function() onTapBasic;
  final double adjustedAngleToTop;
  final double chartYOffset;

  const ChartGestureDetector({
    super.key,
    required this.chart,
    required this.dataList,
    required this.centralCircleRadiusMod,
    required this.offsetForLabels,
    required this.chartTransition,
    required this.chartTransitionValue,
    required this.rotateTransition,
    required this.onTapSector,
    required this.onTapBasic,
    required this.adjustedAngleToTop,
    required this.chartYOffset,
  });

  @override
  State<ChartGestureDetector> createState() => _ChartGestureDetectorState();
}

class _ChartGestureDetectorState extends State<ChartGestureDetector> {
  bool isInited = false;
  late Offset _center;
  late double _chartRadius;
  late double _centralAreaRadius;

  void _onSizeReceived(Size size) {
    _center = Offset(size.width / 2, size.height / 2 + widget.chartYOffset);
    _centralAreaRadius = size.height * widget.centralCircleRadiusMod / 2;
    _chartRadius = size.height / 2 + _centralAreaRadius - widget.offsetForLabels;
    isInited = true;
  }

  void _onTapDown(TapDownDetails details) {
    final isGesturesEnabled = widget.chartTransition.isGesturesEnabled(
      transitionValue: double.parse((widget.chartTransitionValue).toStringAsFixed(2)),
    );

    if (!isInited || widget.dataList.isEmpty || !isGesturesEnabled) {
      return;
    }

    final position = details.localPosition;
    if (_isTapInCircle(_center, _chartRadius, position)) {
      if (_isTapInCircle(_center, _centralAreaRadius, position)) {
        widget.onTapBasic.call();
        return;
      }

      final positionAngle = _calcTapPositionAngle(_center, position);
      widget.onTapSector.call(_getSectorByAngle(widget.dataList, _normalizedAngle(positionAngle)));
      return;
    }
  }

  bool _isTapInCircle(
    Offset circleCenter,
    double circleRadius,
    Offset tapPos,
  ) {
    final matchX = pow(tapPos.dx - circleCenter.dx, 2);
    final matchY = pow(tapPos.dy - circleCenter.dy, 2);
    return (matchX + matchY) < pow(circleRadius, 2);
  }

  double _calcTapPositionAngle(
    Offset circleCenter,
    Offset tapPos,
  ) {
    final a = circleCenter;
    final c = tapPos;
    final atanDifCA = atan2(c.dy - a.dy, c.dx - a.dx);
    final atanDifAC = atan2(a.dy - c.dy, a.dx - c.dx);
    return atanDifCA > 0 ? atanDifCA : pi + atanDifAC;
  }

  ChartSectorModel _getSectorByAngle(
    List<ChartSectorModel> sectorsData,
    double angle,
  ) {
    final sectorAngle = 2 * pi / sectorsData.length;
    for (int i = 0; i < sectorsData.length; i++) {
      final startAngle = sectorAngle * i;
      final endAngle = startAngle + sectorAngle;
      if (startAngle <= angle && angle <= endAngle) {
        return sectorsData[i];
      }
    }
    throw Exception('ChartGestureDetector._getSectorByAngle: wrong args.');
  }

  double _normalizedAngle(double angle) {
    final correctedAngle =
        angle - widget.adjustedAngleToTop - widget.rotateTransition.calcAngleOffset;
    final result = correctedAngle.isNegative ? 2 * pi + correctedAngle : correctedAngle % (2 * pi);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        final minSize = min(size.height, size.width);
        _onSizeReceived(Size(size.width, minSize));
      },
      child: GestureDetector(
        onTapDown: (details) => _onTapDown(details),
        child: widget.chart,
      ),
    );
  }
}
