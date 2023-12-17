import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/chart_state.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/widget/painter/components/circular_axes_component.dart';
import 'package:rose_chart_widget_demo/widget/painter/components/radial_axes_component.dart';
import 'package:rose_chart_widget_demo/widget/painter/components/sectors_group_component.dart';
import 'package:rose_chart_widget_demo/widget/painter/personality_chart_painter.dart';

class CoreChartWidget extends StatefulWidget {
  final List<ChartSectorModelImpl> storyPartViewModels;

  final int filledCount;

  const CoreChartWidget({
    super.key,
    required this.storyPartViewModels,
    required this.filledCount,
  });

  @override
  State<CoreChartWidget> createState() => _CoreChartWidgetState();
}

class _CoreChartWidgetState extends State<CoreChartWidget> {
  double get _centralCircleRadiusMod => 0.45;

  double get _radialStrokeWidth => 2.0;

  double get _offsetForLabels => 21.0;

  final int maxStrength = 2;

  List<ChartSectorModel> get chartSectors =>
      widget.storyPartViewModels.map((e) => e.copyWith(strength: 0)).toList();

  @override
  Widget build(BuildContext context) {
    const chartXOffset = 0.0;
    const chartYOffset = 0.0;

    final RotateTransition rotateTransition =
        RotateTransition.initial(sectorsData: widget.storyPartViewModels);

    return SizedBox(
      height: 200,
      width: 200,
      child: CustomPaint(
        size: Size.infinite,
        painter: PersonalityChartPainter(
          transitionValue: 1,
          transition: const ChartTransition(
            fromState: ChartState.base(),
            toState: ChartState.base(),
          ),
          components: [
            CircularAxesComponent(
              axesCount: maxStrength,
              context: context,
              centralCircleRadiusMod: _centralCircleRadiusMod,
              offsetForLabels: _offsetForLabels,
              chartXOffset: chartXOffset,
              chartYOffset: chartYOffset,
            ),
            SectorsGroupComponent(
              context: context,
              sectorsData: chartSectors,
              maxStrength: maxStrength,
              centralCircleRadiusMod: _centralCircleRadiusMod,
              fillColorOpacity: 0.33,
              centralSectorsMaxCount: chartSectors.length,
              centralSectorsActiveCount: widget.filledCount,
              offsetForLabels: _offsetForLabels,
              rotateTransition: rotateTransition,
              chartXOffset: chartXOffset,
              chartYOffset: chartYOffset,
              adjustedAngleToTop: 0.0,
            ),
            RadialAxesComponent(
              axesCount: chartSectors.length,
              maxStrength: maxStrength,
              axesColor: const Color(0xFF1C1F22),
              strokeWidth: _radialStrokeWidth,
              offsetForLabels: _offsetForLabels,
              rotateTransition: rotateTransition,
              chartXOffset: chartXOffset,
              chartYOffset: chartYOffset,
            ),
          ],
        ),
      ),
    );
  }
}
