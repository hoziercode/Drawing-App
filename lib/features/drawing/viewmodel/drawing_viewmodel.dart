import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/brush_model.dart';
import '../data/models/stroke_model.dart';

final drawingViewModelProvider =
    StateNotifierProvider<DrawingViewModel, BrushModel>((ref) {
  return DrawingViewModel();
});

final strokesProvider = StateProvider<List<StrokeModel>>((_) => []);

final recentColorsProvider = StateProvider<List<Color>>((_) => []);

class DrawingViewModel extends StateNotifier<BrushModel> {
  DrawingViewModel() : super(const BrushModel(color: Colors.white, size: 8));

  StrokeModel? _current;

  void startStroke(Offset p, WidgetRef ref) {
    _current = StrokeModel(points: [p], color: state.color, size: state.size);
    ref.read(strokesProvider.notifier).state = [
      ...ref.read(strokesProvider),
      _current!
    ];
  }

  void updateStroke(Offset p, WidgetRef ref) {
    if (_current == null) return;
    _current = _current!.addPoint(p);

    final strokes = [...ref.read(strokesProvider)];
    strokes[strokes.length - 1] = _current!;
    ref.read(strokesProvider.notifier).state = strokes;
  }

  void endStroke() => _current = null;

  List<StrokeModel> liveStrokes(WidgetRef ref) => ref.watch(strokesProvider);

  void changeBrushColor(Color c, WidgetRef ref) {
    state = state.copyWith(color: c);

    // Save recent colors
    final recents = ref.read(recentColorsProvider);
    if (!recents.contains(c)) {
      ref.read(recentColorsProvider.notifier).state =
          ([c, ...recents]).take(6).toList();
    }
  }

  void undo(WidgetRef ref) {
    final strokes = [...ref.read(strokesProvider)];
    if (strokes.isNotEmpty) {
      strokes.removeLast();
      ref.read(strokesProvider.notifier).state = strokes;
    }
  }

  void clear(WidgetRef ref) {
    ref.read(strokesProvider.notifier).state = [];
  }

  void changeBrushSize(double s) => state = state.copyWith(size: s);

  void updateBrushSize(double newSize) {
    if (newSize >= 1 && newSize <= 50) {
      state = state.copyWith(size: newSize);
    }
  }
}
