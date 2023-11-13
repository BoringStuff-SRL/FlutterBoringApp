import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:flutter/material.dart';

import '../boring_app.dart';

const persistentSide = 750;

Widget content<T>(
    BuildContext context,
    Widget child,
    BoringNavigationPosition navigationPosition,
    BoxConstraints constraints,
    Widget? navigationWidget,
    Widget? appBar,
    BoringThemeConfig theme) {
  if (navigationWidget == null) {
    return child;
  }

  final childContent = appBar != null
      ? Column(
          children: [
            appBar,
            Expanded(child: child),
          ],
        )
      : child;

  switch (navigationPosition) {
    case BoringNavigationPosition.bottom:
    case BoringNavigationPosition.top:
      return child;
    default:
      if (constraints.maxWidth < persistentSide) {
        return childContent;
      }
      return Row(
        children: [
          if (navigationPosition == BoringNavigationPosition.left) ...[
            navigationWidget,
            SizedBox(
              width: theme.widthSpace,
            ),
          ],
          Expanded(child: childContent),
          if (navigationPosition == BoringNavigationPosition.right) ...[
            SizedBox(
              width: theme.widthSpace,
            ),
            navigationWidget
          ],
        ],
      );
  }
}
