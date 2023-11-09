import 'dart:async';

import 'package:boring_app/boring_app/pages/boring_page_group.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../boring_app.dart';

class BoringStaticRouter {
  static GoRouter? goRouter;
}

class BoringApp extends StatelessWidget {
  BoringApp(
      {super.key,
      BoringNavigation? boringNavigation,
      required List<BoringPage> pages,
      this.themeConfig = const BoringThemeConfig(),
      this.redirect,
      this.initialLocation,
      this.rootNavigator,
      this.localizationsDelegates,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.locale,
      this.refreshListenable,
      this.debug = kDebugMode})
      : _pageGroups = [BoringPageGroup(pages: pages)],
        boringNavigation = boringNavigation ?? BoringNavigationDrawer();

  BoringApp.withGroups(
      {super.key,
      BoringNavigation? boringNavigation,
      required List<BoringPageGroup> pageGroups,
      this.themeConfig = const BoringThemeConfig(),
      this.redirect,
      this.initialLocation,
      this.rootNavigator,
      this.localizationsDelegates,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.locale,
      this.refreshListenable,
      this.debug = kDebugMode})
      : _pageGroups = pageGroups,
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
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  List<RouteBase> get _routes =>
      _pageGroups.map((e) => e.routes).expand((element) => element).toList();

  List<BoringNavigationGroup> get navigationGroups =>
      _pageGroups.map((e) => e.navigationGroup()).toList();

  ShellRoute _shellRoute() {
    return ShellRoute(
      routes: _routes,
      builder: (context, state, child) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.all(themeConfig.appPadding),
        child: boringNavigation.buildWithContent(
            state, child, navigationGroups, context, themeConfig),
      ),
    );
  }

  // GoRouter configuration
  void _computeRouter() {
    BoringStaticRouter.goRouter ??= GoRouter(
        debugLogDiagnostics: debug,
        initialLocation: initialLocation,
        redirect: redirect,
        refreshListenable: refreshListenable,
        navigatorKey: rootNavigator,
        routes: [_shellRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    _computeRouter();
    return MaterialApp.router(
      //routerConfig: _goRouter,
      localizationsDelegates: localizationsDelegates,
      routeInformationParser:
          BoringStaticRouter.goRouter!.routeInformationParser,
      routeInformationProvider:
          BoringStaticRouter.goRouter!.routeInformationProvider,
      routerDelegate: BoringStaticRouter.goRouter!.routerDelegate,
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
  final double appPadding;
  final double widthSpace;

  const BoringThemeConfig(
      {this.theme,
      this.darkTheme,
      this.highContrastTheme,
      this.highContrastDarkTheme,
      this.themeMode = ThemeMode.system,
      this.appPadding = 20,
      this.widthSpace = 20});
}
