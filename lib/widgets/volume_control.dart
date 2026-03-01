import 'package:flutter/material.dart';

class VolumeControl extends StatefulWidget {
  final double value; // 0-100
  final Function(double) onChanged;

  const VolumeControl({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  late double _previousVolume;

  @override
  void initState() {
    super.initState();
    _previousVolume = widget.value > 0 ? widget.value : 50;
  }

  IconData _getVolumeIcon(double value) {
    if (value == 0) return Icons.volume_off;
    if (value <= 50) return Icons.volume_down;
    return Icons.volume_up;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.value > 0) {
              _previousVolume = widget.value;
              widget.onChanged(0);
            } else {
              widget.onChanged(_previousVolume);
            }
          },
          child: Icon(
            _getVolumeIcon(widget.value),
            color: colors.onSurface,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              final box = context.findRenderObject() as RenderBox;
              final newValue = (details.localPosition.dx / box.size.width).clamp(0.0, 1.0) * 100;
              widget.onChanged(newValue);
            },
            onTapDown: (details) {
              final box = context.findRenderObject() as RenderBox;
              final newValue = (details.localPosition.dx / box.size.width).clamp(0.0, 1.0) * 100;
              widget.onChanged(newValue);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Progress
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: widget.value / 100,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
