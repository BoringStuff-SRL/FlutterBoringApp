import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:flutter/material.dart';

import '../../boring_app.dart';
import '../boring_app.dart';
import 'navigation_entry.dart';

const persistentSide = 750;

Widget content<T>(
    BuildContext context,
    Widget child,
    BoringNavigationPosition navigationPosition,
    BoxConstraints constraints,
    Widget? navigationWidget,
    ValueNotifier<T>? appBarNotifier,
AppBar? Function(BuildContext, GoRouterState, List<BoringNavigationGroupWithSelection>, ValueNotifier<T>?, bool)? appBarBuilder,
    GoRouterState state,
    List<BoringNavigationGroupWithSelection> navGroup,
    bool drawerVisible,

    BoringThemeConfig theme) {
  if (navigationWidget == null) {
    return child;
  }


  print('REBUILD');
  final childContent = Column(
    children: [
      Container(width: double.infinity,
      height: 50, color: Colors.red,),

      Expanded(child: child),
    ],
  );

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
      return Padding(
        padding: EdgeInsets.all(theme.appPadding),
        child: Row(
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
        ),
      );
  }
}
