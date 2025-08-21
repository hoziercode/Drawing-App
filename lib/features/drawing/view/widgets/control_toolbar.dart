// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodel/drawing_viewmodel.dart';
import 'brush_preview.dart';
import 'color_picker_sheet.dart';

class ControlToolbar extends ConsumerWidget {
  const ControlToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(drawingViewModelProvider.notifier);
    final brush = ref.watch(drawingViewModelProvider);
    final recents = ref.watch(recentColorsProvider);

    return SafeArea(
      minimum: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                BrushPreview(color: brush.color, size: brush.size),
                const SizedBox(width: 14),

                // Brush Size Controls
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Brush Size',
                        style: TextStyle(fontSize: 12, color: Colors.white70),),
                  ],
                ),
                const SizedBox(width: 10),

               Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: brush.size,
                              min: 1,
                              max: 20,
                              onChanged: (v) => vm.changeBrushSize(v),
                            ),
                          ),
                          const SizedBox(width: 3),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            transitionBuilder: (child, anim) =>
                                FadeScaleTransition(animation: anim, child: child),
                            child: Text(
                              brush.size.toStringAsFixed(0),
                              key: ValueKey(brush.size.toStringAsFixed(0)),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Color Picker Button
                IconButton(
                  tooltip: 'Color',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF14161A),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: ColorPickerSheet(
                          initial: brush.color,
                          recent: recents,
                          onSelected: (c) {
                            vm.changeBrushColor(c, ref);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.color_lens_outlined,
                      color: Colors.white),
                ),

                const SizedBox(width: 8),

                // Undo Button
                IconButton(
                  tooltip: 'Undo',
                  onPressed: () => vm.undo(ref),
                  icon: const Icon(Icons.undo, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
