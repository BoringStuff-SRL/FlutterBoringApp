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

abstract class BoringNavigation<T> {
  abstract final bool embraceAppBar;
  abstract final BoringNavigationPosition navigationPosition;
  final ValueNotifier<T>? appBarNotifier;
  final AppBar? Function(
      BuildContext context,
      GoRouterState state,
      List<BoringNavigationGroupWithSelection> navGroups,
      ValueNotifier<T>? appBarNotifier)? appBarBuilder;

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

  Widget _child(BuildContext context, BoxConstraints constraints, Widget child,
      Widget? navigationWidget, AppBar? appBar, BoringThemeConfig theme) {
    return content(context, child, navigationPosition, constraints,
        navigationWidget, appBar, theme);
  }

  bool _appBarShouldGoWithContent(BoxConstraints constraints) =>
      embraceAppBar &&
      navigationPosition.isSide &&
      constraints.maxWidth > persistentSide;

  AppBar? _topAppBar(
      BuildContext context, BoxConstraints constraints, AppBar? appBar) {
    return (appBar == null || _appBarShouldGoWithContent(constraints))
        ? null
        : appBar;
  }

  AppBar? _contentAppBar(
      BuildContext context, BoxConstraints constraints, AppBar? appBar) {
    return (appBar != null && _appBarShouldGoWithContent(constraints))
        ? appBar
        : null;
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
      final appBar =
          appBarBuilder?.call(context, state, navGroups, appBarNotifier);
      return Scaffold(
        drawer: (!drawerVisible && navigationPosition.isRight) ? drawer : null,
        endDrawer:
            (!drawerVisible && navigationPosition.isRight) ? drawer : null,
        appBar: _topAppBar(context, constraints, appBar),
        bottomNavigationBar: _bottomNav(context, navGroups, constraints),
        body: _child(context, constraints, child, drawer,
            _contentAppBar(context, constraints, appBar), theme),
      );
    });
  }
}
