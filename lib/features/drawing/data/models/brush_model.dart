import 'package:flutter/material.dart';

class BrushModel {
  final Color color;
  final double size;

  const BrushModel({required this.color, required this.size});

  BrushModel copyWith({Color? color, double? size}) =>
      BrushModel(color: color ?? this.color, size: size ?? this.size);
}
