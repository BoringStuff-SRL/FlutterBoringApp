// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/breakpoints.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../boring_app.dart';

enum BoringNavigationPosition { top, bottom, left, right }

extension BoringNavigationPositionUtils on BoringNavigationPosition {
  bool get isSide =>
      this == BoringNavigationPosition.left ||
      this == BoringNavigationPosition.right;

  bool get isRight => this == BoringNavigationPosition.right;

  bool get isLeft => this == BoringNavigationPosition.left;
}

typedef AppBarBuilder<T> = PreferredSizeWidget? Function(
    BuildContext context,
    GoRouterState state,
    List<BoringNavigationGroupWithSelection> navGroups,
    ValueNotifier<T>? appBarNotifier,
    bool isDrawerVisible);

abstract class BoringNavigation<T> {
  abstract final bool embraceAppBar;
  abstract final BoringNavigationPosition navigationPosition;
  final ValueNotifier<T>? appBarNotifier;
  final AppBarBuilder<T>? appBarBuilder;

  BoringNavigation({this.appBarNotifier, this.appBarBuilder});

  Widget builder(
      BuildContext context,
      List<BoringNavigationGroupWithSelection> navigationGroups,
      BoxConstraints constraints);

  Widget? _drawer(
          BuildContext context,
          List<BoringNavigationGroupWithSelection> navigationGroups,
          BoxConstraints constraints) =>
      builder(context, navigationGroups, constraints);

  Widget? _bottomNav(
          BuildContext context,
          List<BoringNavigationGroupWithSelection> navigationGroups,
          BoxConstraints constraints) =>
      navigationPosition == BoringNavigationPosition.bottom
          ? builder(context, navigationGroups, constraints)
          : null;

  PreferredSizeWidget? _topNav(
          BuildContext context,
          List<BoringNavigationGroupWithSelection> navigationGroups,
          BoxConstraints constraints) =>
      navigationPosition == BoringNavigationPosition.top
          ? builder(context, navigationGroups, constraints)
              as PreferredSizeWidget
          : null;

  Widget _child(BuildContext context, BoxConstraints constraints, Widget child,
      Widget? navigationWidget, Widget? appBar, BoringThemeConfig theme) {
    return content(context, child, navigationPosition, constraints,
        navigationWidget, appBar, theme);
  }

  bool isDrawerVisible(BoxConstraints constraints) =>
      constraints.maxWidth > persistentSide;

  Widget buildWithContent(
    GoRouterState state,
    Widget child,
    List<BoringNavigationGroup> navigationGroups,
    BuildContext context,
    BoringThemeConfig theme,
  ) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool drawerVisible = isDrawerVisible(constraints);
      final navGroups = navigationGroups.withSelection(state);
      final drawer = _drawer(context, navGroups, constraints);

      BoringNavigationEntryWithSelection? entry;

      try {
        // cerco la sezione per impostare il titolo della tab
        entry = navGroups.expand((element) => element.entries).firstWhere(
              (element) => state.fullPath!.startsWith(element.path),
            );
      } catch (e) {}

      // final appBar =
      //     appBarBuilder?.call(context, state, navGroups, appBarNotifier);
      return Title(
        color: Colors.white,
        title: entry?.label ?? '',
        child: Scaffold(
          drawer:
              (!drawerVisible && !navigationPosition.isRight) ? drawer : null,
          endDrawer:
              (!drawerVisible && navigationPosition.isRight) ? drawer : null,
          appBar: _topNav(context, navGroups, constraints),
          bottomNavigationBar: _bottomNav(context, navGroups, constraints),
          body: _child(
              context,
              constraints,
              child,
              drawer,
              //_contentAppBar(context, constraints, appBar),
              appBarBuilder != null
                  ? ValueListenableBuilder(
                      valueListenable: appBarNotifier!,
                      builder: (context, value, child) {
                        return appBarBuilder!.call(context, state, navGroups,
                                appBarNotifier, drawerVisible) ??
                            Container();
                      },
                    )
                  : null,
              theme),
        ),
      );
    });
  }
}
