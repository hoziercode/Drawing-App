import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerSheet extends StatefulWidget {
  final Color initial;
  final List<Color> recent;
  final ValueChanged<Color> onSelected;

  const ColorPickerSheet({
    super.key,
    required this.initial,
    required this.recent,
    required this.onSelected,
  });

  @override
  State<ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<ColorPickerSheet> {
  late Color tmp;
  bool showApplyButton = false;

  @override
  void initState() {
    super.initState();
    tmp = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pick a color',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  BlockPicker(
                    pickerColor: widget.initial,
                    onColorChanged: (c) {
                      setState(() {
                        tmp = c;
                        showApplyButton = tmp != widget.initial;
                      });
                    },
                  ),
                  if (widget.recent.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Recent',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.recent.map((c) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              tmp = c;
                              showApplyButton = tmp != widget.initial;
                            });
                          },
                          child: CircleAvatar(backgroundColor: c, radius: 14),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),

        // Floating Apply Button
        Positioned(
          bottom: 20,
          right: 20,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            offset: showApplyButton ? Offset.zero : const Offset(0, 2),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: showApplyButton ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: FloatingActionButton.extended(
                onPressed: () => widget.onSelected(tmp),
                label: const Text("Apply"),
                icon: const Icon(Icons.check),
                backgroundColor: tmp,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
