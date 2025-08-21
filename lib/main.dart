import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/drawing/view/drawing_screen.dart';

void main() {
  runApp(const ProviderScope(child: DrawingApp()));
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Canvas',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const DrawingScreen(),
    );
  }
}
