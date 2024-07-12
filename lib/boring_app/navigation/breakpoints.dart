import 'package:boring_app/boring_app/boring_app.dart';
import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:flutter/material.dart';

const persistentSide = 750;

Widget content<T>(
  BuildContext context,
  Widget child,
  BoringNavigationPosition navigationPosition,
  BoxConstraints constraints,
  Widget? navigationWidget,
  Widget? appBar,
  BoringThemeConfig theme,
) {
  if (navigationWidget == null) {
    return child;
  }

  final childContent = appBar != null
      ? Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: theme.widthSpace,
                top: theme.widthSpace,
                right: theme.widthSpace,
              ),
              child: appBar,
            ),
            Expanded(child: child),
          ],
        )
      : child;

  switch (navigationPosition) {
    case BoringNavigationPosition.bottom:
    case BoringNavigationPosition.top:
      return Padding(
        padding: EdgeInsets.all(theme.appPadding),
        child: child,
      );
    default:
      if (constraints.maxWidth < persistentSide) {
        return childContent;
      }
      return Row(
        children: [
          if (navigationPosition == BoringNavigationPosition.left) ...[
            Padding(
              padding: EdgeInsets.only(
                left: theme.widthSpace,
                top: theme.widthSpace,
                bottom: theme.widthSpace,
              ),
              child: navigationWidget,
            ),
          ],
          Expanded(child: childContent),
          if (navigationPosition == BoringNavigationPosition.right) ...[
            SizedBox(
              width: theme.widthSpace,
            ),
            navigationWidget,
          ],
        ],
      );
  }
}
