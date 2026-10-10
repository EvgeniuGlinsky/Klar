import 'package:flutter/material.dart';
import 'package:klar/ui/theme/klar_dimens.dart';
import 'package:klar/ui/theme/klar_typography.dart';

/// A modal bottom sheet with a quiet title and scrollable content.
Future<T?> showKlarSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  bool expand = false,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  // Above the tab bar, not inside the tab's navigator.
  useRootNavigator: true,
  builder: (context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * (expand ? 0.92 : 0.8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(KlarDimens.gutter, 0, KlarDimens.gutter, 12),
              child: Text(title, style: KlarTypography.title),
            ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: SafeArea(top: false, child: Builder(builder: builder)),
            ),
          ),
        ],
      ),
    ),
  ),
);
