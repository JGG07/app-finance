import 'package:flutter/material.dart';

class BudgetCategory {
  const BudgetCategory({
    required this.id,
    required this.title,
    required this.limit,
    this.spent = 0.0,
    required this.color,
  });

  final String id;
  final String title;
  final double limit;
  final double spent;
  final Color color;

  BudgetCategory copyWith({
    String? title,
    double? limit,
    double? spent,
    Color? color,
  }) {
    return BudgetCategory(
      id: id,
      title: title ?? this.title,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      color: color ?? this.color,
    );
  }
}
