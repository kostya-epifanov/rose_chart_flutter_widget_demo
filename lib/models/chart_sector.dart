import 'package:equatable/equatable.dart';
import 'package:rose_chart_widget_demo/models/category.dart';

abstract class ChartSectorModel {
  final int strength;
  final Category category;

  const ChartSectorModel({
    required this.strength,
    required this.category,
  });
}

class ChartSectorModelImpl extends Equatable implements ChartSectorModel {
  @override
  final int strength;
  @override
  final Category category;

  final bool isEmpty;

  bool get isNotEmpty => !isEmpty;

  const ChartSectorModelImpl({
    required this.strength,
    required this.category,
    required this.isEmpty,
  });

  ChartSectorModelImpl copyWith({
    int? strength,
    Category? category,
    bool? isEmpty,
  }) {
    return ChartSectorModelImpl(
      strength: strength ?? this.strength,
      category: category ?? this.category,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  List<Object> get props => [
        strength,
        category,
      ];
}
