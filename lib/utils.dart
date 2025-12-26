import 'dart:math';
import 'dart:ui';

import 'package:rose_chart_widget_demo/models/category.dart';
import 'package:rose_chart_widget_demo/models/chart_sector.dart';

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
  int minSize = 6,
  int maxSize = 8,
  int minStrength = 1,
  int maxStrength = demoChartSectorMaxStrength + 1,
  bool isInitial = false,
}) {
  final size = minSize + Random().nextInt(maxSize - minSize);
  return List.generate(size, (index) {
    return ChartSectorModelImpl(
      strength: isInitial ? 0 : minStrength + Random().nextInt(maxStrength - minStrength),
      category: Category(name: 'RND$index'),
      isEmpty: false,
    );
  });
}

List<ChartSectorModelImpl> generateFixedTestList() {
  return [
    const ChartSectorModelImpl(
      strength: 0,
      category: Category(name: 'Sector A'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 1,
      category: Category(name: 'Sector B'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 2,
      category: Category(name: 'Sector C'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 3,
      category: Category(name: 'Sector D'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 4,
      category: Category(name: 'Sector E'),
      isEmpty: false,
    ),
    const ChartSectorModelImpl(
      strength: 5,
      category: Category(name: 'Sector F'),
      isEmpty: false,
    ),
  ];
}
