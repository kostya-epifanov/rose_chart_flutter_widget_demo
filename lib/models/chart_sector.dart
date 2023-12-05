import 'package:equatable/equatable.dart';
import 'package:rose_chart_widget_demo/models/context_category.dart';

abstract class ChartSectorModel {
  final int strength;
  final ContextCategory contextCategory;

  const ChartSectorModel({
    required this.strength,
    required this.contextCategory,
  });
}

class ChartSectorModelImpl extends Equatable implements ChartSectorModel {
  @override
  final int strength;
  @override
  final ContextCategory contextCategory;

  final bool isEmpty;

  bool get isNotEmpty => !isEmpty;

  const ChartSectorModelImpl({
    required this.strength,
    required this.contextCategory,
    required this.isEmpty,
  });

  @override
  List<Object> get props => [
        strength,
        contextCategory,
      ];

  ChartSectorModelImpl copyWith({
    int? strength,
    ContextCategory? contextCategory,
    bool? isEmpty,
  }) {
    return ChartSectorModelImpl(
      strength: strength ?? this.strength,
      contextCategory: contextCategory ?? this.contextCategory,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}
