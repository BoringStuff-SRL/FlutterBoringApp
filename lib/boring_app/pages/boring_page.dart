// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class BoringPageWidget extends BoringPage {
  final Widget Function(BuildContext context, GoRouterState state)
      _widgetBuilder;
  final BoringNavigationEntry _widgetNavigationEntry;
  BoringPageWidget(
      {required BoringNavigationEntry navigationEntry,
      required Widget Function(BuildContext context, GoRouterState state)
          builder,
      super.subPages,
      super.hideFromNavigation = false,
      super.giftSelectionWhenHidden = true,
      super.redirect,
      super.preventNavigationDisplay})
      : _widgetNavigationEntry = navigationEntry,
        _widgetBuilder = builder;

  @override
  Widget builder(BuildContext context, GoRouterState state) =>
      _widgetBuilder(context, state);

  @override
  BoringNavigationEntry get navigationEntry => _widgetNavigationEntry;
}

abstract class BoringPage {
  abstract final BoringNavigationEntry navigationEntry;
  Widget builder(BuildContext context, GoRouterState state);

  final bool hideFromNavigation;
  final bool giftSelectionWhenHidden;
  final Future<String?> Function(BuildContext, GoRouterState)? redirect;
  final List<BoringPage> subPages;
  final bool preventNavigationDisplay;
  BoringPage(
      {this.subPages = const [],
      this.hideFromNavigation = false,
      this.giftSelectionWhenHidden = true,
      this.redirect,
      this.preventNavigationDisplay = false});

  GoRoute route(GlobalKey<NavigatorState> rootNavigatorKey,
      {String prefix = "", String? rootPrefix}) {
    String path = navigationEntry.path;
    String currentFullPath = prefix.pathAppend(path);
    if (rootPrefix != null) {
      currentFullPath =
          rootPrefix.pathAppend(currentFullPath, mustStartWithSlash: true);
      path = rootPrefix.pathAppend(path, mustStartWithSlash: true);
    }
    //PATH = {rootPrefix}/{_navigationEntry.path}
    //FULL_PATH = {rootPrefix}/{prefix}/{_navigationEntry.path}
    return GoRoute(
        parentNavigatorKey: preventNavigationDisplay ? rootNavigatorKey : null,
        path: path,
        pageBuilder: (context, state) {
          if (state.fullPath != currentFullPath) {
            return NoTransitionPage(child: Container());
          }
          return NoTransitionPage(child: builder(context, state));
        },
        redirect: redirect,
        routes: subPages
            .map((e) => e.route(rootNavigatorKey, prefix: currentFullPath))
            .toList());
  }

  BoringNavigationEntryWithSubEntries navigationEntryWithSubentries(
          {String initPath = ""}) =>
      BoringNavigationEntryWithSubEntries.from(
          navigationEntry.copyWithPath(initPath.pathAppend(navigationEntry.path,
              mustStartWithSlash: true)),
          subPages
              // .where((element) => !element.hideFromNavigation)
              .map((e) => e.navigationEntryWithSubentries(
                  initPath: initPath.pathAppend(navigationEntry.path,
                      mustStartWithSlash: true)))
              .toList(),
          hideFromNavigation,
          giftSelectionWhenHidden);
}

class MyPage extends BoringPage {
  @override
  // TODO: implement _navigationEntry
  BoringNavigationEntry get navigationEntry => throw UnimplementedError();

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    // TODO: implement builder
    throw UnimplementedError();
  }
}

extension on String {
  String pathAppend(String other, {bool mustStartWithSlash = false}) {
    if (isEmpty) return other;
    String res = "$this/$other".replaceAll("//", "/").trim();
    if (res.endsWith("/")) {
      res = res.substring(0, res.length - 1);
    }
    if (mustStartWithSlash && !res.startsWith("/")) {
      res = "/$res";
    }
    return res;
  }
}
