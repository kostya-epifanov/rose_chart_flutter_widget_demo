import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ContextCategory extends Equatable {
  final String name;
  // final bool isObligated;

  Color get color {
    switch (name) {
      case 'Goals':
        return const Color.fromRGBO(187, 231, 63, 1);
      case 'Physiological':
        return const Color.fromRGBO(255, 185, 79, 1);
      case 'Hidden Detail':
        return const Color.fromRGBO(247, 85, 124, 1);
      case 'Intellectual':
        return const Color.fromRGBO(230, 116, 255, 1);
      case 'Psychological':
        return const Color.fromRGBO(79, 102, 255, 1);
      case 'Habits':
        return const Color.fromRGBO(86, 217, 138, 1);
      default:
        // throw Exception('ContextCategory: unsupported name: $name');
        return Colors.grey;
    }
  }

  const ContextCategory.empty() : this(name: '');

  bool get isEmpty => name.isEmpty;

  String get title => name.replaceAll('_', ' ').toUpperCase();

  const ContextCategory({
    required this.name,
  });

  factory ContextCategory.fromMap(Map<String, dynamic> map) {
    return ContextCategory(
      name: map['name'] ?? '',
    );
  }

  factory ContextCategory.fromJson(String source) =>
      ContextCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ContextCategory(name: $name)';

  @override
  List<Object> get props => [name];
}

extension ContextCategoryX on ContextCategory {
  static List<ContextCategory> fromJsonList(String data) => (jsonDecode(data) as List)
      .map((e) => ContextCategory.fromMap(e as Map<String, dynamic>))
      .toList();

  static ContextCategory fromJson(String json) => ContextCategory.fromJson(json);
}
