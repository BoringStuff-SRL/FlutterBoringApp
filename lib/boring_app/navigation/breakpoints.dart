import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:flutter/material.dart';

const persistentSide = 750;

Widget content(
    BuildContext context,
    Widget child,
    BoringNavigationPosition navigationPosition,
    BoxConstraints constraints,
    Widget? navigationWidget,
    AppBar? appBar) {
  if (navigationWidget == null) {
    return child;
  }
  final childContent = appBar != null
      ? Column(
          children: [appBar, Expanded(child: child)],
        )
      : child;

  switch (navigationPosition) {
    case BoringNavigationPosition.bottom:
    case BoringNavigationPosition.top:
      return child;
    default:
      if (constraints.maxWidth < persistentSide) {
        return child;
      }
      return Row(
        children: [
          if (navigationPosition == BoringNavigationPosition.left)
            navigationWidget,
          Expanded(child: childContent),
          if (navigationPosition == BoringNavigationPosition.right)
            navigationWidget,
        ],
      );
  }
}