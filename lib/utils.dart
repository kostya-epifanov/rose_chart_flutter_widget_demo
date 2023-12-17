import 'dart:math';
import 'dart:ui';

import 'package:rose_chart_widget_demo/models/chart_sector.dart';
import 'package:rose_chart_widget_demo/models/context_category.dart';

Color getRandomColor() {
  final rnd = Random();
  return Color.fromRGBO(
    rnd.nextInt(255),
    rnd.nextInt(255),
    rnd.nextInt(255),
    1,
  );
}

List<ChartSectorModelImpl> generateRandomSizeTestList({
  int minSize = 4,
  int maxSize = 12,
  int minStrength = 0,
  int maxStrength = demoChartSectorMaxStrength + 1,
  bool isInitial = false,
}) {
  final size = minSize + Random().nextInt(maxSize - minSize);
  return List.generate(size, (index) {
    return ChartSectorModelImpl(
      strength: isInitial ? 0 : minStrength + Random().nextInt(maxStrength - minStrength),
      contextCategory: ContextCategory(name: 'RND$index'),
      isEmpty: false,
    );
  });
}

List<ChartSectorModelImpl> generateFixedTestList() {
  return [
    const ChartSectorModelImpl(
      strength: 0,
      contextCategory: ContextCategory(name: 'Goals'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 1,
      contextCategory: ContextCategory(name: 'Physiological'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 2,
      contextCategory: ContextCategory(name: 'Hidden Detail'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 3,
      contextCategory: ContextCategory(name: 'Intellectual'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 4,
      contextCategory: ContextCategory(name: 'Psychological'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 5,
      contextCategory: ContextCategory(name: 'Habits'),
      isEmpty: false,
    ),
  ];
}
