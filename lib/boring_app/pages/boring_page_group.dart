// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app.dart';
import 'package:flutter/widgets.dart';

class BoringPageGroup {
  final String? name;
  final Widget? icon;
  final bool hideFromNavigation;

  final List<BoringPage> pages;

  const BoringPageGroup({
    required this.pages,
    this.hideFromNavigation = false,
    this.name,
    this.icon,
  });

  BoringNavigationGroup navigationGroup({String? rootPrefix}) {
    return BoringNavigationGroup(
      name: name,
      icon: icon,
      hideFromNavigation: hideFromNavigation,
      entries: pages
          .map(
            (e) => e.navigationEntryWithSubentries(
              initPath: rootPrefix ?? '',
            ),
          )
          .toList(),
    );
  }

  List<RouteBase> routes(
    GlobalKey<NavigatorState> rootNavigatorKey, {
    required BoringThemeConfig theme,
    required bool? displayedWithNavigation,
    String? rootPrefix,
    RedirectCallback? redirect,
  }) =>
      pages
          .where(
            (element) =>
                (displayedWithNavigation == null) ||
                element.preventNavigationDisplay != displayedWithNavigation,
          )
          .map(
            (e) => e.route(
              rootNavigatorKey,
              rootPrefix: rootPrefix,
              theme: theme,
              displayWithNavigation: displayedWithNavigation,
              globalRedirect: redirect,
            ),
          )
          .toList();
}
