// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:boring_app/boring_app/boring_app_section.dart';
import 'package:boring_app/boring_app/boring_drawer.dart';
import 'package:boring_app/boring_app/boring_drawer_section.dart';

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
  BoringApp({
    super.key,
    required this.sections,
    this.drawerFooterBuilder,
    this.drawerHeaderBuilder,
    this.themeConfig = const BoringThemeConfig(),
  });
  final BoringThemeConfig themeConfig;
  final List<BoringAppSection> sections;
  final Widget Function(BuildContext context)? drawerHeaderBuilder;
  final Widget Function(BuildContext context)? drawerFooterBuilder;

  BoringDrawer drawer(String? path) => BoringDrawer(
        path: path,
        sections: sections
            .map((e) => e.drawerSection)
            .whereType<BoringDrawerSection>()
            .toList(),
        headerBuilder: drawerHeaderBuilder,
        footerBuilder: drawerFooterBuilder,
      );

  List<GoRoute> routes(bool? insideDrawer) => sections
      .map((e) => (insideDrawer != null && insideDrawer == e.exludeFromDrawer)
          ? null
          : e.routes)
      .whereType<List<GoRoute>>()
      .expand((element) => element)
      .toList();

  late final GoRouter _goRouter = GoRouter(debugLogDiagnostics: true, routes: [
    ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body:
                Row(children: [drawer(state.location), Expanded(child: child)]),
          );
        },
        routes: routes(true)),
    ...routes(false),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _goRouter.routeInformationParser,
      routeInformationProvider: _goRouter.routeInformationProvider,
      routerDelegate: _goRouter.routerDelegate,
      //them section
      theme: themeConfig.theme,
      darkTheme: themeConfig.darkTheme,
      highContrastTheme: themeConfig.highContrastTheme,
      highContrastDarkTheme: themeConfig.highContrastDarkTheme,
      themeMode: themeConfig.themeMode,
    );
  }
}
