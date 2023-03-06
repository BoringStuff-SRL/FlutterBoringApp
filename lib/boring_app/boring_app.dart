import 'dart:async';

import 'package:boring_app/boring_app/boring_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class BoringApp extends StatelessWidget {
  BoringApp(
      {super.key,
      required this.sections,
      this.themeConfig = const BoringThemeConfig(),
      this.redirect,
      this.initialLocation,
      this.refreshListenable}) {
    checkDuplicates();
  }

  checkDuplicates() {
    final s = <dynamic>{};
    for (var section in sections) {
      if (s.contains(section.path)) {
        throw Exception("Duplicate path for sections: '${section.path}'");
      }
      s.add(section.path);
    }
  }

  final BoringThemeConfig themeConfig;
  final List<BoringSection> sections;
  final _rootNavigator = GlobalKey<NavigatorState>();
  final FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;
  final String? initialLocation;
  final Listenable? refreshListenable;

  get getRootRoutes => sections
      .where((element) => !element.hasPath)
      .map((e) => e.subRoutes())
      .expand((element) => element)
      .toList();

  late final GoRouter _goRouter = GoRouter(
      debugLogDiagnostics: false,
      initialLocation: initialLocation,
      redirect: redirect,
      refreshListenable: refreshListenable,
      navigatorKey: _rootNavigator,
      routes: [
        ...getRootRoutes,
        ...sections
            .where((element) => element.hasPath)
            .map((e) => e.route(_rootNavigator))
            .toList()
      ]);

  printRoutes(List<RouteBase> routes, int indent) {
    if (routes.isEmpty) {
      return;
    }
    for (var route in routes) {
      //print("${'-' * indent}>${route}");
      //printRoutes(route.routes, indent + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    //printRoutes(_goRouter.routeConfiguration.routes, 0);

    return MaterialApp.router(
      routerConfig: _goRouter,
      // routeInformationParser: _goRouter.routeInformationParser,
      // routeInformationProvider: _goRouter.routeInformationProvider,
      // routerDelegate: _goRouter.routerDelegate,
      theme: themeConfig.theme,
      darkTheme: themeConfig.darkTheme,
      highContrastTheme: themeConfig.highContrastTheme,
      highContrastDarkTheme: themeConfig.highContrastDarkTheme,
      themeMode: themeConfig.themeMode,
    );
  }
}
