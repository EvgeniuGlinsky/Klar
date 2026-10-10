import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.color = KlarColors.textFaint, this.trailing, this.onTap, super.key});

  final String title;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 28, KlarDimens.gutter, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(title.toUpperCase(), style: KlarTypography.label.copyWith(color: color)),
          ),
          ?trailing,
        ],
      ),
    ),
  );
}
