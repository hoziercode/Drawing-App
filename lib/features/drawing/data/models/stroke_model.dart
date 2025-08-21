import 'package:flutter/material.dart';

class StrokeModel {
  final List<Offset> points;
  final Color color;
  final double size;

  StrokeModel({
    required this.points,
    required this.color,
    required this.size,
  });

  StrokeModel addPoint(Offset p) =>
      StrokeModel(points: [...points, p], color: color, size: size);
}
