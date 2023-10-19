// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/breakpoints.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum BoringNavigationPosition { top, bottom, left, right }

extension BoringNavigationPositionUtils on BoringNavigationPosition {
  bool get isSide =>
      this == BoringNavigationPosition.left ||
      this == BoringNavigationPosition.right;
}

abstract class BoringNavigation<T> {
  abstract final bool embraceAppBar;
  abstract final BoringNavigationPosition navigationPosition;
  final ValueNotifier<T>? appBarNotifier;
  final AppBar? Function(
      BuildContext context, ValueNotifier<T>? appBarNotifier)? appBarBuilder;
  BoringNavigation({this.appBarNotifier, this.appBarBuilder});
  Widget builder(
      BuildContext context,
      List<BoringNavigationGroupWithSelection> navigationGroups,
      BoxConstraints constraints);
  // BoringNavigation({
  //   required this.navigationPosition,
  //   required this.builder,
  // }) : assert(navigationPosition != BoringNavigationPosition.top,
  //           "TOP NAV STILL NOT ALLOWED");

  Widget? _drawer(
          BuildContext context,
          List<BoringNavigationGroupWithSelection> navigationGroups,
          BoxConstraints constraints) =>
      navigationPosition == BoringNavigationPosition.left
          ? builder(context, navigationGroups, constraints)
          : null;
  Widget? _endDrawer(
          BuildContext context,
          List<BoringNavigationGroupWithSelection> navigationGroups,
          BoxConstraints constraints) =>
      navigationPosition == BoringNavigationPosition.right
          ? builder(context, navigationGroups, constraints)
          : null;
  Widget? _bottomNav(
          BuildContext context,
          List<BoringNavigationGroupWithSelection> navigationGroups,
          BoxConstraints constraints) =>
      navigationPosition == BoringNavigationPosition.bottom
          ? builder(context, navigationGroups, constraints)
          : null;
  Widget _child(BuildContext context, BoxConstraints constraints, Widget child,
      Widget? navigationWidget, AppBar? appBar) {
    return content(context, child, navigationPosition, constraints,
        navigationWidget, appBar);
  }

  bool _appBarShouldGoWithContent(BoxConstraints constraints) =>
      embraceAppBar &&
      navigationPosition.isSide &&
      constraints.maxWidth > persistentSide;

  AppBar? _appBarBuilder() {
    final AppBar appBar = AppBar(
      title: const Text("APPBAR"),
    );
    return appBar;
  }

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

  Widget buildWithContent(
    GoRouterState state,
    Widget child,
    List<BoringNavigationGroup> navigationGroups,
    BuildContext context,
  ) {
    return LayoutBuilder(builder: (context, constraints) {
      final navGroups = navigationGroups.withSelection(state);
      final drawer = _drawer(context, navGroups, constraints);
      final endDrawer = _endDrawer(context, navGroups, constraints);
      final appBar = _appBarBuilder();
      return Scaffold(
        drawer:
            constraints.maxWidth < persistentSide ? drawer : null, //_drawer(),
        endDrawer: constraints.maxWidth < persistentSide ? endDrawer : null,
        appBar: _topAppBar(context, constraints, appBar),
        bottomNavigationBar: _bottomNav(context, navGroups, constraints),
        body: _child(context, constraints, child, drawer ?? endDrawer,
            _contentAppBar(context, constraints, appBar)),
      );
    });
  }
}

// class CustomBoringNavigation extends BoringNavigation {
//   @override
//   final BoringNavigationPosition navigationPosition;
//   final Widget Function(
//       BuildContext context,
//       List<BoringNavigationGroupWithSelection> navigationGroups,
//       BoxConstraints constraints) _customBuilder;
//   CustomBoringNavigation({
//     this.embraceAppBar = true,
//     required this.navigationPosition,
//     required Widget Function(
//             BuildContext context,
//             List<BoringNavigationGroupWithSelection> navigationGroups,
//             BoxConstraints constraints)
//         builder,
//   }) : _customBuilder = builder;

//   @override
//   Widget builder(
//           BuildContext context,
//           List<BoringNavigationGroupWithSelection> navigationGroups,
//           BoxConstraints constraints) =>
//       _customBuilder(context, navigationGroups, constraints);

//   @override
//   final bool embraceAppBar;
// }
