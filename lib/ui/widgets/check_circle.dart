import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Round checkbox: an outline tinted with [color] that fills with sage when done.
class CheckCircle extends StatelessWidget {
  const CheckCircle({required this.done, required this.onTap, this.color = KlarColors.lineStrong, this.size = 24, super.key});

  final bool done;
  final VoidCallback onTap;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    checked: done,
    button: true,
    child: InkResponse(
      onTap: onTap,
      radius: size,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? KlarColors.sage : Colors.transparent,
            border: Border.all(color: done ? KlarColors.sage : color, width: 1.5),
          ),
          child: AnimatedScale(
            scale: done ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: Icon(PhosphorIconsBold.check, size: size * 0.55, color: KlarColors.onAccent),
          ),
        ),
      ),
    ),
  );
}
