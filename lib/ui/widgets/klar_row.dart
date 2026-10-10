import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// A settings-style row: icon, title, optional value and subtitle, chevron when tappable.
class KlarRow extends StatelessWidget {
  const KlarRow({
    required this.title,
    this.icon,
    this.iconColor = KlarColors.textMuted,
    this.value,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.selected = false,
    super.key,
  });

  final String title;
  final IconData? icon;
  final Color iconColor;
  final String? value;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final titleColor = !enabled ? KlarColors.textFaint : (selected ? KlarColors.birch : KlarColors.text);
    return InkWell(
      onTap: enabled ? onTap : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: KlarDimens.rowHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: KlarDimens.gutter, vertical: 10),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 22, color: enabled ? iconColor : KlarColors.textFaint),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: KlarTypography.body.copyWith(color: titleColor)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: KlarTypography.meta),
                    ],
                  ],
                ),
              ),
              if (value != null)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.42),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      value!,
                      style: KlarTypography.bodyMuted.copyWith(
                        color: enabled ? KlarColors.textMuted : KlarColors.textFaint,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
