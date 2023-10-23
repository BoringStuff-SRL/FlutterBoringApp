// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class BoringPage {
  final BoringNavigationEntry _navigationEntry;
  Widget Function(BuildContext context, GoRouterState state) builder;
  final bool hideFromNavigation;
  final bool giftSelectionWhenHidden;
  Future<String?> Function(BuildContext, GoRouterState)? redirect;

  List<BoringPage> subPages;
  BoringPage(
      {required BoringNavigationEntry navigationEntry,
      required this.builder,
      this.subPages = const [],
      this.hideFromNavigation = false,
      this.giftSelectionWhenHidden = true,
      this.redirect})
      : _navigationEntry = navigationEntry;

  GoRoute route(String prefix) {
    final currentFullPath = prefix.pathAppend(_navigationEntry.path);
    return GoRoute(
        path: _navigationEntry.path,
        pageBuilder: (context, state) {
          if (state.fullPath != currentFullPath) {
            return NoTransitionPage(child: Container());
          }
          return NoTransitionPage(child: builder(context, state));
        },
        redirect: redirect,
        routes: subPages.map((e) => e.route(currentFullPath)).toList());
  }

  BoringNavigationEntryWithSubEntries navigationEntryWithSubentries(
          {String initPath = ""}) =>
      BoringNavigationEntryWithSubEntries.from(
          _navigationEntry
              .copyWithPath(initPath.pathAppend(_navigationEntry.path)),
          subPages
              // .where((element) => !element.hideFromNavigation)
              .map((e) => e.navigationEntryWithSubentries(
                  initPath: initPath.pathAppend(_navigationEntry.path)))
              .toList(),
          hideFromNavigation,
          giftSelectionWhenHidden);
}

extension on String {
  String pathAppend(String other) {
    if (isEmpty) return other;
    return "$this/$other".replaceAll("//", "/");
  }
}
