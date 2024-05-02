// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../boring_app.dart';

class BoringStaticRouter {
  static GoRouter? goRouter;
}

class BoringAppInstance {
  final BoringThemeConfig? themeConfig;
  final String? path;
  final BoringNavigation boringNavigation;
  final List<BoringPageGroup> _pageGroups;

  BoringAppInstance({
    this.themeConfig,
    required this.path,
    required this.boringNavigation,
    required List<BoringPage> pages,
  }) : _pageGroups = [BoringPageGroup(pages: pages)];
  BoringAppInstance.withGroups({
    this.themeConfig,
    required this.path,
    required this.boringNavigation,
    required List<BoringPageGroup> pageGroups,
  }) : _pageGroups = pageGroups;

  List<RouteBase> _routes(GlobalKey<NavigatorState> rootNavigatorKey,
      {bool? displayedWithNavigation}) {
    return _pageGroups
        .map((e) => e.routes(rootNavigatorKey,
            rootPrefix: path, displayedWithNavigation: displayedWithNavigation))
        .expand((element) => element)
        .toList();
  }

  ShellRoute? shellRoute(GlobalKey<NavigatorState> rootNavigatorKey,
      BoringThemeConfig rootThemeConfig) {
    final appThemeConfig = themeConfig ?? rootThemeConfig;
    final routes = _routes(rootNavigatorKey, displayedWithNavigation: true);
    if (routes.isEmpty) {
      return null;
    }
    return ShellRoute(
      // navigatorKey: GlobalKey<NavigatorState>(),
      // parentNavigatorKey: rootNavigatorKey,
      routes: routes,
      builder: (context, state, child) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: boringNavigation.buildWithContent(
              state, child, _navigationGroups, context, appThemeConfig),
        );
      },
    );
  }

  List<RouteBase> routesWithoutNavigation(
          GlobalKey<NavigatorState> rootNavigatorKey) =>
      _routes(rootNavigatorKey, displayedWithNavigation: false);

  List<BoringNavigationGroup> get _navigationGroups =>
      _pageGroups.map((e) => e.navigationGroup(rootPrefix: path)).toList();

  bool get isOnRoot => (path == null) || (path!.isEmpty);
}

class BoringApp extends StatelessWidget {
  final List<BoringAppInstance> applications;
  final GlobalKey<NavigatorState> _defaultRootNavigatorKey =
      GlobalKey<NavigatorState>();

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
      : applications = [
          BoringAppInstance(
              path: "",
              pages: pages,
              boringNavigation: boringNavigation ?? BoringNavigationDrawer())
        ];

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
      : applications = [
          BoringAppInstance.withGroups(
              path: "",
              pageGroups: pageGroups,
              boringNavigation: boringNavigation ?? BoringNavigationDrawer())
        ];

  BoringApp.multiApp(
      {super.key,
      BoringNavigation? boringNavigation,
      // required List<BoringPage> pages,
      this.themeConfig = const BoringThemeConfig(),
      this.redirect,
      this.initialLocation,
      this.rootNavigator,
      this.localizationsDelegates,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.locale,
      this.refreshListenable,
      this.debug = kDebugMode,
      required this.applications})
      : assert(_checkOnlyOneIsRoot(applications));

  static bool _checkOnlyOneIsRoot(List<BoringAppInstance> apps) =>
      apps.where((app) => app.isOnRoot).length < 2;

  get _rootNavigatorKey => rootNavigator ?? _defaultRootNavigatorKey;

  List<ShellRoute> get _shellRoutes => applications
      .map((app) => app.shellRoute(_rootNavigatorKey, themeConfig))
      .where((element) => element != null)
      .toList()
      .cast<ShellRoute>();
  List<RouteBase> get _routesWithoutNavigation => applications
      .map((app) => app.routesWithoutNavigation(_rootNavigatorKey))
      .expand((element) => element)
      .toList();

  void _computeRouter() {
    BoringStaticRouter.goRouter ??= GoRouter(
        debugLogDiagnostics: debug,
        initialLocation: initialLocation,
        redirect: redirect,
        refreshListenable: refreshListenable,
        navigatorKey: _rootNavigatorKey,
        routes: [..._shellRoutes, ..._routesWithoutNavigation]);
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
