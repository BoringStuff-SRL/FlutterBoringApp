import 'dart:async';

import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:boring_app/boring_app/navigation/drawer/boring_navigation_drawer.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:boring_app/boring_app/pages/boring_page.dart';
import 'package:boring_app/boring_app/pages/boring_page_group.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringApp extends StatelessWidget {
  BoringApp(
      {super.key,
      BoringNavigation? boringNavigation,
      required List<BoringPage> pages,
      this.themeConfig = const BoringThemeConfig(),
      this.redirect,
      this.initialLocation,
      this.rootNavigator,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.locale,
      this.refreshListenable,
      this.debug = kDebugMode})
      : _pageGroups = [BoringPageGroup(pages: pages)],
        boringNavigation = boringNavigation ?? BoringNavigationDrawer();

  final BoringNavigation boringNavigation;
  final List<BoringPageGroup> _pageGroups;
  final BoringThemeConfig themeConfig;
  final GlobalKey<NavigatorState>? rootNavigator;
  final FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;
  final String? initialLocation;
  final Listenable? refreshListenable;
  final Iterable<Locale> supportedLocales;
  final Locale? locale;
  final bool debug;

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
        debugLogDiagnostics: debug,
        redirect: redirect,
        refreshListenable: refreshListenable,
        navigatorKey: rootNavigator,
        routes: [_shellRoute()],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router(),
      supportedLocales: supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: debug,
      theme: themeConfig.theme,
      darkTheme: themeConfig.darkTheme,
      highContrastTheme: themeConfig.highContrastTheme,
      highContrastDarkTheme: themeConfig.highContrastDarkTheme,
      themeMode: themeConfig.themeMode,
    );
  }
}

class BoringThemeConfig {
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final ThemeMode? themeMode;

  const BoringThemeConfig({
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
  });
}
