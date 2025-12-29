import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rose_chart_widget_demo/utils.dart';

const int demoChartSectorMaxStrength = 6;

class Category extends Equatable {
  final String name;

  Color get color {
    switch (name) {
      case 'Category A':
      case 'Sector A':
        return const Color.fromRGBO(187, 231, 63, 1);
      case 'Category B':
      case 'Sector B':
        return const Color.fromRGBO(255, 185, 79, 1);
      case 'Category C':
      case 'Sector C':
        return const Color.fromRGBO(247, 85, 124, 1);
      case 'Category D':
      case 'Sector D':
        return const Color.fromRGBO(230, 116, 255, 1);
      case 'Category E':
      case 'Sector E':
        return const Color.fromRGBO(79, 102, 255, 1);
      case 'Category F':
      case 'Sector F':
        return const Color.fromRGBO(86, 217, 138, 1);
      default:
        return getRandomColor();
    }
  }

  const Category.empty() : this(name: '');

  bool get isEmpty => name.isEmpty;

  String get title => name.replaceAll('_', ' ').toUpperCase();

  const Category({
    required this.name,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
    );
  }

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Category(name: $name)';

  @override
  List<Object> get props => [name];
}

extension CategoryX on Category {
  static List<Category> fromJsonList(String data) =>
      (jsonDecode(data) as List).map((e) => Category.fromMap(e as Map<String, dynamic>)).toList();

  static Category fromJson(String json) => Category.fromJson(json);
}
