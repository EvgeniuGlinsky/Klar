import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klar/l10n/app_localizations.dart';
import 'package:klar/ui/theme/klar_colors.dart';
import 'package:klar/ui/theme/klar_icons.dart';
import 'package:klar/ui/theme/klar_typography.dart';

class ShellScaffold extends StatelessWidget {
  const ShellScaffold({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final items = [
      (KlarIcons.sun, l10n.navToday),
      (KlarIcons.calendarDots, l10n.navUpcoming),
      (KlarIcons.listBullets, l10n.navLists),
      (KlarIcons.gearSix, l10n.navSettings),
    ];
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: KlarColors.background,
          border: Border(top: BorderSide(color: KlarColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (final (i, (icon, label)) in items.indexed)
                  Expanded(
                    child: _NavItem(
                      icon: icon,
                      label: label,
                      selected: shell.currentIndex == i,
                      onTap: () => shell.goBranch(i, initialLocation: i == shell.currentIndex),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? KlarColors.birch : KlarColors.textFaint;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Icon(icon, key: ValueKey(selected), size: 24, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, style: KlarTypography.meta.copyWith(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}
