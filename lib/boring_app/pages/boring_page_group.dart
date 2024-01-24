// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:boring_app/boring_app/pages/boring_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class BoringPageGroup {
  final String? name;
  //TODO add icon [and display option]
  final List<BoringPage> pages;
  const BoringPageGroup({
    this.name,
    required this.pages,
  });

  BoringNavigationGroup navigationGroup({String? rootPrefix}) {
    return BoringNavigationGroup(
        name: name,
        entries: pages
            .map((e) =>
                e.navigationEntryWithSubentries(initPath: rootPrefix ?? ""))
            .toList());
  }

  List<RouteBase> routes(GlobalKey<NavigatorState> rootNavigatorKey,
          {String? rootPrefix, bool? displayedWithNavigation}) =>
      pages
          .where((element) => (displayedWithNavigation != null)
              ? element.preventNavigationDisplay != displayedWithNavigation
              : true)
          .map((e) => e.route(rootNavigatorKey, rootPrefix: rootPrefix))
          .toList();
}
