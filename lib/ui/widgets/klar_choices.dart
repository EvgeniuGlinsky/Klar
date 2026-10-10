import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// A wrap of pill-shaped single-choice options.
class KlarChoices<T> extends StatelessWidget {
  const KlarChoices({
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: KlarDimens.gutter),
    super.key,
  });

  final List<T> values;
  final T? selected;
  final String Function(T value) label;
  final Widget Function(T value)? leading;
  final ValueChanged<T> onSelected;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          KlarPill(
            label: label(value),
            selected: value == selected,
            leading: leading?.call(value),
            onTap: () => onSelected(value),
          ),
      ],
    ),
  );
}

class KlarPill extends StatelessWidget {
  const KlarPill({required this.label, required this.onTap, this.selected = false, this.leading, super.key});

  final String label;
  final bool selected;
  final Widget? leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? KlarColors.birch : Colors.transparent,
    shape: StadiumBorder(side: BorderSide(color: selected ? KlarColors.birch : KlarColors.lineStrong)),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(
              label,
              style: KlarTypography.meta.copyWith(
                fontSize: 13.5,
                color: selected ? KlarColors.onAccent : KlarColors.text,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
