// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BrushPreview extends StatefulWidget {
  final Color color;
  final double size;
  const BrushPreview({super.key, required this.color, required this.size});

  @override
  State<BrushPreview> createState() => _BrushPreviewState();
}

class _BrushPreviewState extends State<BrushPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double d = max(24, widget.size * 2.2);

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final scale = 0.95 + (_c.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.55),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
                const BoxShadow(
                  color: AppColors.glow,
                  blurRadius: 28,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
