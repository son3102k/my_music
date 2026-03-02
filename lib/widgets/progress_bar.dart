import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final double value; // 0-1
  final double buffer; // 0-1 amount downloaded/buffered
  final double max;
  final Function(double) onChanged;

  const ProgressBar({
    Key? key,
    required this.value,
    this.buffer = 0.0,
    this.max = 1.0,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  bool _isDragging = false;
  late double _dragValue;

  @override
  void initState() {
    super.initState();
    _dragValue = widget.value;
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging) {
      _dragValue = widget.value;
    }
  }

  String _formatDuration(double seconds) {
    final int totalSeconds = seconds.toInt();
    final int minutes = totalSeconds ~/ 60;
    final int secs = totalSeconds % 60;
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currentValue = _isDragging ? _dragValue : widget.value;
    final bufferValue = widget.buffer.clamp(0.0, 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: GestureDetector(
        onHorizontalDragStart: (_) {
          setState(() => _isDragging = true);
        },
        onHorizontalDragUpdate: (details) {
          final box = context.findRenderObject() as RenderBox;
          final localOffset = details.localPosition.dx;
          final newValue = (localOffset / box.size.width).clamp(0.0, 1.0);
          setState(() => _dragValue = newValue);
        },
        onHorizontalDragEnd: (_) {
          setState(() => _isDragging = false);
          widget.onChanged(_dragValue);
        },
        onTapDown: (details) {
          final box = context.findRenderObject() as RenderBox;
          final newValue = (details.localPosition.dx / box.size.width).clamp(0.0, 1.0);
          widget.onChanged(newValue);
        },
        child: Column(
          children: [
            SizedBox(
              height: 24,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = constraints.maxWidth;
                  final thumbPos = (barWidth * currentValue).clamp(0.0, barWidth);
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background bar
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Buffered amount bar (grey)
                      Container(
                        height: 4,
                        width: barWidth * bufferValue,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Progress bar (played)
                      Container(
                        height: 4,
                        width: barWidth * currentValue,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Thumb
                      Positioned(
                        left: thumbPos - 6,
                        top: -4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.onSurface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(currentValue * widget.max),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  _formatDuration(widget.max),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
