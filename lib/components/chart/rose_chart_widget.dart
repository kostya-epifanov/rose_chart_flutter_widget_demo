import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/transitions/chart_state.dart';
import 'package:rose_chart_widget_demo/transitions/chart_transition.dart';
import 'package:rose_chart_widget_demo/transitions/rotate_transition.dart';
import 'package:rose_chart_widget_demo/components/gestures/chart_gesture_detector.dart';
import 'package:rose_chart_widget_demo/components/rendering/effects/bottom_fade_gradient_component.dart';
import 'package:rose_chart_widget_demo/components/rendering/axes/circular_axes_component.dart';
import 'package:rose_chart_widget_demo/components/rendering/labels/labels_component.dart';
import 'package:rose_chart_widget_demo/components/rendering/axes/radial_axes_component.dart';
import 'package:rose_chart_widget_demo/components/rendering/sectors/sectors_group_component.dart';
import 'package:rose_chart_widget_demo/components/rendering/painter/rose_chart_painter.dart';

class RoseChartWidget extends StatefulWidget {
  final int maxStrength;
  final List<ChartSectorModelImpl> storyPartViewModels;

  List<ChartSectorModel> get chartSectors =>
      storyPartViewModels.map((e) => e.isEmpty ? e.copyWith(strength: 0) : e).toList();

  final ChartSectorModel sectorOnTop;
  final int centralSectorsActiveCount;
  final ChartTransition transition;
  final double transitionAnimationValue;

  final void Function() onTapSelectorLeft;
  final void Function() onTapSelectorRight;

  final void Function(ChartSectorModel) onTapSector;
  final void Function() onTapBasic;

  const RoseChartWidget({
    super.key,
    required this.maxStrength,
    required this.storyPartViewModels,
    required this.sectorOnTop,
    required this.centralSectorsActiveCount,
    required this.transition,
    required this.transitionAnimationValue,
    required this.onTapSelectorLeft,
    required this.onTapSelectorRight,
    required this.onTapSector,
    required this.onTapBasic,
  });

  @override
  State<RoseChartWidget> createState() => _RoseChartWidgetState();
}

class _RoseChartWidgetState extends State<RoseChartWidget> with SingleTickerProviderStateMixin {
  double get _centralCircleRadiusMod => 0.25;

  double get _radialStrokeWidth => 2.0;

  double get _offsetForLabels => 21.0;

  late AnimationController _rotateAnimationController;
  late Animation<double> _rotateAnimation;
  late RotateTransition _rotateTransition;

  @override
  void initState() {
    _rotateTransition = RotateTransition.initial(sectorsData: widget.storyPartViewModels);
    _rotateAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
        _rotateTransition.transitionValue = _rotateAnimation.value;
        setState(() {});
      });

    _rotateAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotateAnimationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rotateChart(widget.chartSectors.first, widget.sectorOnTop);
    });

    super.initState();
  }

  @override
  void dispose() {
    _rotateAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RoseChartWidget oldWidget) {
    if (oldWidget.sectorOnTop.category != widget.sectorOnTop.category) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _rotateChart(oldWidget.sectorOnTop, widget.sectorOnTop);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _rotateChart(ChartSectorModel prev, ChartSectorModel next) {
    final nextRotateTransition = RotateTransition(
      sectorsData: widget.storyPartViewModels,
      previousTopSector: prev,
      nextTopSector: next,
    );

    _rotateTransition = nextRotateTransition;

    _rotateAnimationController.reset();
    _rotateAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final chartXOffset =
        widget.transition.getChartXOffset(transitionValue: widget.transitionAnimationValue);

    final chartYOffset =
        widget.transition.calcChartYOffset(transitionValue: widget.transitionAnimationValue);

    final adjustedAngleToTop = -pi / 2 - (pi / widget.chartSectors.length);

    return ClipRect(
      child: Padding(
        padding: EdgeInsets.only(top: _offsetForLabels),
        child: SizedBox(
          width: double.infinity,
          height: widget.transition.calcWidgetHeight(
            transitionValue: widget.transitionAnimationValue,
          ),
          child: Stack(
            children: [
              ChartGestureDetector(
                adjustedAngleToTop: adjustedAngleToTop,
                dataList: widget.chartSectors,
                centralCircleRadiusMod: _centralCircleRadiusMod,
                offsetForLabels: _offsetForLabels,
                chartTransitionValue: widget.transitionAnimationValue,
                chartTransition: widget.transition,
                rotateTransition: _rotateTransition,
                onTapSector: widget.onTapSector,
                onTapBasic: widget.onTapBasic,
                chartYOffset: chartYOffset,
                chart: CustomPaint(
                  size: Size.infinite,
                  painter: RoseChartPainter(
                    transitionValue: widget.transitionAnimationValue,
                    transition: widget.transition,
                    components: [
                      CircularAxesComponent(
                        axesCount: widget.maxStrength,
                        context: context,
                        centralCircleRadiusMod: _centralCircleRadiusMod,
                        offsetForLabels: _offsetForLabels,
                        chartXOffset: chartXOffset,
                        chartYOffset: chartYOffset,
                      ),
                      SectorsGroupComponent(
                        context: context,
                        sectorsData: widget.chartSectors,
                        maxStrength: widget.maxStrength,
                        centralCircleRadiusMod: _centralCircleRadiusMod,
                        fillColorOpacity: 0.33,
                        centralSectorsMaxCount: widget.chartSectors.length,
                        centralSectorsActiveCount: widget.centralSectorsActiveCount,
                        offsetForLabels: _offsetForLabels,
                        rotateTransition: _rotateTransition,
                        chartXOffset: chartXOffset,
                        chartYOffset: chartYOffset,
                        adjustedAngleToTop: adjustedAngleToTop,
                      ),
                      RadialAxesComponent(
                        axesCount: widget.chartSectors.length,
                        maxStrength: widget.maxStrength,
                        axesColor: const Color(0xFF1C1F22),
                        strokeWidth: _radialStrokeWidth,
                        offsetForLabels: _offsetForLabels,
                        rotateTransition: _rotateTransition,
                        chartXOffset: chartXOffset,
                        chartYOffset: chartYOffset,
                      ),
                      /*if (widget.transition.havePluses)
                        PlusIconsComponent(
                          adjustedAngleToTop: adjustedAngleToTop,
                          sectorsData: widget.chartSectors,
                          centralCircleRadiusMod: _centralCircleRadiusMod,
                          axesCount: widget.chartSectors.length,
                          plusIconBackgroundColor: plusIconBackgroundColor,
                          plusIconColor: plusIconColor,
                          offsetForLabels: _offsetForLabels,
                          rotateTransition: _rotateTransition,
                          chartYOffset: chartYOffset,
                          isShowCenterPlus: widget.centralSectorsActiveCount == 0,
                        ),*/
                      LabelsComponent(
                        adjustedAngleToTop: adjustedAngleToTop,
                        data: widget.chartSectors,
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        centralCircleRadiusMod: _centralCircleRadiusMod,
                        offsetForLabels: _offsetForLabels,
                        centralLabelText: 'BASIC',
                        centralLabelMarkColor: Colors.blueAccent,
                        markHeight: 8.0,
                        markWidth: 10.0,
                        markOffset: 3.0,
                        transition: widget.transition,
                        stateTransitionValue: widget.transitionAnimationValue,
                        rotateTransition: _rotateTransition,
                        chartXOffset: chartXOffset,
                        chartYOffset: chartYOffset,
                      ),
                      BottomFadeGradientComponent(
                        color: const Color(0xFF1C1F22),
                        transition: widget.transition,
                        transitionValue: widget.transitionAnimationValue,
                        chartXOffset: chartXOffset,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.transition.toState == const ChartState.detailed()) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: _widgetSelectorButton(isLeft: true),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _widgetSelectorButton(isLeft: false),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetSelectorButton({
    required bool isLeft,
  }) {
    return Opacity(
      opacity: 1,
      child: SizedBox(
        width: 48,
        height: 48,
        child: ClipOval(
          child: MaterialButton(
            minWidth: 24,
            height: 24,
            onPressed: () =>
                isLeft ? widget.onTapSelectorLeft.call() : widget.onTapSelectorRight.call(),
            highlightColor: Colors.transparent,
            child: isLeft
                ? const Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                    size: 16.0,
                  )
                : const Icon(
                    Icons.chevron_left,
                    color: Colors.grey,
                    size: 16.0,
                  ),
          ),
        ),
      ),
    );
  }
}
