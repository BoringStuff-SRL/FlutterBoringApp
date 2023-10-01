import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:boring_app/boring_app/navigation/drawer/boring_navigation_drawer.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:boring_app/boring_app/pages/boring_page.dart';
import 'package:boring_app/boring_app/pages/boring_page_group.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringApp extends StatelessWidget {
  BoringApp(
      {super.key,
      BoringNavigation? boringNavigation,
      required List<BoringPage> pages})
      : _pageGroups = [BoringPageGroup(pages: pages)],
        boringNavigation = boringNavigation ?? BoringNavigationDrawer();
  final BoringNavigation boringNavigation;
  final List<BoringPageGroup> _pageGroups;
  List<RouteBase> get _routes =>
      _pageGroups.map((e) => e.routes).expand((element) => element).toList();

  List<BoringNavigationGroup> get navigationGroups =>
      _pageGroups.map((e) => e.navigationGroup()).toList();

  ShellRoute _shellRoute() {
    return ShellRoute(
      routes: _routes,
      builder: (context, state, child) => boringNavigation.buildWithContent(
          state, child, navigationGroups, context),
    );
  }

  // GoRouter configuration
  GoRouter _router() => GoRouter(
        debugLogDiagnostics: true,
        routes: [_shellRoute()],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router(),
    );
  }
}
