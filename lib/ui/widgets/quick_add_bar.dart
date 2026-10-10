import 'package:flutter/material.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// A pill-shaped input for adding a task with one line; the trailing button opens the full editor.
class QuickAddBar extends StatefulWidget {
  const QuickAddBar({required this.onSubmit, required this.onExpand, super.key});

  final ValueChanged<String> onSubmit;

  /// Opens the editor with what was typed so far.
  final ValueChanged<String> onExpand;

  @override
  State<QuickAddBar> createState() => _QuickAddBarState();
}

class _QuickAddBarState extends State<QuickAddBar> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _focus.unfocus();
      return;
    }
    widget.onSubmit(text);
    _controller.clear();
  }

  void _expand() {
    final text = _controller.text.trim();
    _controller.clear();
    _focus.unfocus();
    widget.onExpand(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: KlarColors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: KlarColors.line),
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            const Icon(KlarIcons.plus, size: 20, color: KlarColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                style: KlarTypography.body,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: l10n.quickAddHint),
                onSubmitted: (_) => _submit(),
                onTapOutside: (_) => _focus.unfocus(),
              ),
            ),
            IconButton(
              tooltip: l10n.quickAddMore,
              onPressed: _expand,
              icon: const Icon(KlarIcons.arrowUpRight, size: 20, color: KlarColors.textMuted),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}

/// Keeps [child] above the keyboard and the system navigation bar.
class BottomDock extends StatelessWidget {
  const BottomDock({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x00121314), KlarColors.background],
        stops: [0, 0.35],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: KlarDimens.gutter),
      child: child,
    ),
  );
}
