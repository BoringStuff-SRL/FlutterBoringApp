// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:boring_app/boring_app/style/boring_drawer_style.dart';
import 'package:boring_app/boring_app/boring_page/boring_page.dart';
import 'package:boring_app/boring_app/style/boring_drawer_tile_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringSection {
  final String? path;
  final Widget Function(BuildContext context)? drawerHeaderBuilder;
  final Widget Function(BuildContext context)? drawerFooterBuilder;
  final String? defaultPath;
  final BoringDrawerStyle drawerStyle;
  final BoringDrawerTileStyle drawerTileStyle;
  final List<int> dividersAtIndexes;
  final Widget Function(BuildContext context)? dividerBuilder;
  final FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<BoringPageBase> children;

  BoringSection(
      {this.path,
      required this.children,
      this.drawerHeaderBuilder,
      this.drawerFooterBuilder,
      this.defaultPath,
      this.redirect,
      this.dividerBuilder,
      this.dividersAtIndexes = const [],
      this.drawerStyle = const BoringDrawerStyle(),
      this.drawerTileStyle = const BoringDrawerTileStyle()}) {
    _assertions();
  }

  _assertions() {
    //assert(hasPath == ;
    final emptyPathPage = children
        .map((e) => e.getPagesWithEmptyPath())
        .expand((element) => element)
        .toList();
    if (emptyPathPage.length > 1) {
      throw Exception(
          "Multiple children with empty path are not allowed inside the same section!");
    }
    final hasDefaultPath = (defaultPath != null &&
        defaultPath!
            .isNotEmpty); //, "If path exists, defaultPath must exist too! And viceversa!");
    if (emptyPathPage.isNotEmpty) {
      // if (!hasPath) {
      //   throw Exception(
      //       "You can't have a page with empty path inside a section with empty path!");
      // }
      if (hasDefaultPath) {
        throw Exception(
            "Default path must be null because inside this section there's a page with empty path that'll be the root of this section!");
      }
      noPathPage = emptyPathPage[0];
    } else {
      noPathPage = null;
      if (hasPath != hasDefaultPath) {
        throw Exception(
            "The section has a non empty path but there's no page inside with an empty path. In order to work, add a default path to be redirected to!");
      }
    }
  }

  late final BoringPage? noPathPage;

  drawerWrap(Widget child) => Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: child,
      );

  Drawer drawer(BuildContext context) {
    List<Widget> _children = children
        .map((e) =>
            e.buildDrawerEntry(context, drawerTileStyle, hasPath ? path! : ""))
        .whereType<Widget>()
        .toList();
    int itemsAdded = 0;
    dividersAtIndexes.forEach((e) {
      _children.insert(
          e + itemsAdded, dividerBuilder?.call(context) ?? const Divider());
      itemsAdded++;
    });

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: drawerStyle.drawerRadius),
      elevation: drawerStyle.drawerElevation,
      child: drawerWrap(Column(
        children: [
          if (drawerHeaderBuilder != null) drawerHeaderBuilder!(context),
          Expanded(
            child: SingleChildScrollView(
              padding: drawerStyle.drawerContentPadding,
              child: Column(
                children: _children,
              ),
            ),
          ),
          if (drawerFooterBuilder != null) drawerFooterBuilder!(context),
        ],
      )),
    );
  }

  List<RouteBase> _getChildrenRoutes(bool hiddenFromDrawer) => children
      .where((element) => element.isHiddenFromDrawer == hiddenFromDrawer)
      .map((e) => e.getRoutes(addPrefix: !hasPath, redirectInjection: redirect))
      .expand((element) => element)
      .toList();

  List<ShellRoute> _shellRoute() {
    print(children);
    final subRoutes = _getChildrenRoutes(false);
    print(subRoutes);
    if (subRoutes.isEmpty) return [];
    return [
      ShellRoute(
          navigatorKey: GlobalKey<NavigatorState>(),
          builder: (context, state, child) {
            return HeroControllerScope(
              controller: MaterialApp.createMaterialHeroController(),
              child: LayoutBuilder(builder: (context, constraints) {
                return Scaffold(
                  key: _drawerKey,
                  drawer: constraints.maxWidth > 750 ? null : drawer(context),
                  body: constraints.maxWidth > 750
                      ? Padding(
                          padding: drawerStyle.drawerForeignPadding,
                          child: Row(children: [
                            drawer(context),
                            Expanded(child: child)
                          ]),
                        )
                      : child,
                );
              }),
            );
          },
          routes: subRoutes)
    ];
  }

  List<RouteBase> subRoutes() =>
      [..._shellRoute(), ..._getChildrenRoutes(true)];

  bool get hasPath => path != null && path!.isNotEmpty;

  RouteBase route([
    GlobalKey<NavigatorState>? parentNavigatorKey,
  ]) {
    assert(hasPath, "Can't have an empty path!");
    return GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        redirect: (context, state) =>
            redirect?.call(context, state) ??
            ((state.fullpath == path) ? defaultPath : null),
        path: path!,
        //TODO this is just a workaround! It should be fixed
        builder: (context, state) =>
            noPathPage?.builder?.call(context, state) ?? const Placeholder(),
        routes: subRoutes());
  }
//TODO add drawer header and footer
}
