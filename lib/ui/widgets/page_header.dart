import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// Large, quiet page title with an optional subtitle and trailing action.
class PageHeader extends StatelessWidget {
  const PageHeader({required this.title, this.subtitle, this.trailing, this.accent, super.key});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  /// Optional thin colored mark above the title (used for lists).
  final Color? accent;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 24, 8, 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (accent != null)
                Container(
                  width: 28,
                  height: 3,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
                ),
              Text(title, style: KlarTypography.display),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: KlarTypography.bodyMuted),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
