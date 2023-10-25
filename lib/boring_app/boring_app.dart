import 'dart:async';

import 'package:boring_app/boring_app/boring_app_section.dart';
import 'package:boring_app/boring_app/boring_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

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
      required this.rootNavigator,
      this.localizationsDelegates,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.locale,
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
  final List<BoringAppSection> sections;
  final GlobalKey<NavigatorState> rootNavigator;
  final FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;
  final String? initialLocation;
  final Listenable? refreshListenable;
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  Iterable<Locale> supportedLocales;
  Locale? locale;

  get getRootRoutes => sections
      .where((element) => !element.hasPath)
      .map((e) => e.subRoutes())
      .expand((element) => element)
      .toList();

  //static final GoRouter _goRouter =

  printRoutes(List<RouteBase> routes, int indent) {
    if (routes.isEmpty) {
      return;
    }
    for (var route in routes) {
      //print("${'-' * indent}>${route}");
      //printRoutes(route.routes, indent + 1);
    }
  }

  static String example = 'asdasd';

  @override
  Widget build(BuildContext context) {
    BoringStaticRouter.goRouter ??= GoRouter(
        debugLogDiagnostics: false,
        initialLocation: initialLocation,
        redirect: redirect,
        refreshListenable: refreshListenable,
        navigatorKey: rootNavigator,
        routes: [
          ...getRootRoutes,
          ...sections
              .where((element) => element.hasPath)
              .map((e) => e.route(rootNavigator))
              .toList()
        ]);

    return MaterialApp.router(
      //routerConfig: _goRouter,
      routeInformationParser:
          BoringStaticRouter.goRouter!.routeInformationParser,
      routeInformationProvider:
          BoringStaticRouter.goRouter!.routeInformationProvider,
      routerDelegate: BoringStaticRouter.goRouter!.routerDelegate,
      localizationsDelegates: [
        SfGlobalLocalizations.delegate,
        ...?localizationsDelegates
      ],
      supportedLocales: supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
      theme: themeConfig.theme,
      darkTheme: themeConfig.darkTheme,
      highContrastTheme: themeConfig.highContrastTheme,
      highContrastDarkTheme: themeConfig.highContrastDarkTheme,
      themeMode: themeConfig.themeMode,
    );
  }
}
