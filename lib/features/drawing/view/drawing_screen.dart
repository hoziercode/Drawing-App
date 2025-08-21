import 'package:drawing_app/features/drawing/painter/drawing_painter.dart';
import 'package:drawing_app/features/drawing/viewmodel/drawing_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/control_toolbar.dart';

class DrawingScreen extends ConsumerStatefulWidget {
  const DrawingScreen({super.key});

  @override
  ConsumerState<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends ConsumerState<DrawingScreen>
    with SingleTickerProviderStateMixin {
  bool _showUI = true;

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(drawingViewModelProvider.notifier);
    final strokes = vm.liveStrokes(ref);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Canvas'),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            child: Text('Clear'),
            onPressed: () => vm.clear(ref),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Listener(
        onPointerDown: (event) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(event.position);
          final toolbarHeight = 120;

          if (localPosition.dy >
              MediaQuery.of(context).size.height - toolbarHeight) {
            return;
          }
          setState(() => _showUI = false);
        },
        onPointerUp: (_) {
          vm.endStroke();
          setState(() => _showUI = true);
        },
        child: GestureDetector(
          onPanStart: (d) => vm.startStroke(d.localPosition, ref),
          onPanUpdate: (d) => vm.updateStroke(d.localPosition, ref),
          onPanEnd: (_) => vm.endStroke(),
          child: Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: DrawingPainter(strokes: strokes),
                  ),
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                offset: _showUI ? Offset.zero : const Offset(0, 1.2),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: ControlToolbar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
