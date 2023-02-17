import 'dart:async';

import 'package:boring_app/boring_app/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/boring_page/boring_page_base.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../style/boring_drawer_tile_style.dart';

export 'package:boring_app/boring_app/boring_page/boring_page_base.dart';

class BoringPage implements BoringPageBase {
  String path;
  String drawerLabel;
  Widget? icon;
  List<BoringPage>? subPages;
  bool hideFromDrawer;
  bool showChildrenInDrawer;
  Widget Function(BuildContext context, GoRouterState state)? builder;
  FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;

  BoringPage(
      {required this.path,
      this.drawerLabel = "",
      this.icon,
      this.subPages,
      this.hideFromDrawer = false,
      this.showChildrenInDrawer = false,
      this.builder,
      this.redirect})
      : assert(!hideFromDrawer || drawerLabel.isEmpty,
            "The page is hidden from the drawer so the drawerLabel must be empty! PATH: $path");

  List<BoringDrawerEntry>? _subDrawerEntries(
          String fullPathPrefix, BoringDrawerTileStyle tileStyle) =>
      showChildrenInDrawer
          ? subPages
              ?.map((e) => e.boringDrawerEntry(fullPathPrefix, tileStyle))
              .where((element) => element != null)
              .toList() as List<BoringDrawerEntry>
          : null;

  BoringDrawerEntry? boringDrawerEntry(
          String fullPathPrefix, BoringDrawerTileStyle tileStyle) =>
      !hideFromDrawer
          ? BoringDrawerEntry(
              path: "$fullPathPrefix/$path",
              label: drawerLabel,
              subEntries: _subDrawerEntries("$fullPathPrefix/$path", tileStyle),
              icon: icon,
              tileStyle: tileStyle,
            )
          : null;

  // @override
  // List<BoringEntry> get getDrawerEntries =>
  //     !hideFromDrawer ? [_boringEntry as BoringEntry] : [];

  @override
  Widget? buildDrawerEntry(
      BuildContext context, BoringDrawerTileStyle tileStyle,
      [String fullPathPrefix = ""]) {
    return boringDrawerEntry(fullPathPrefix, tileStyle);
  }

  @override
  List<GoRoute> getRoutes(
      {bool addPrefix = false,
      FutureOr<String?> Function(BuildContext context, GoRouterState state)?
          redirectInjection}) {
    return [
      if (addPrefix || path.isNotEmpty)
        GoRoute(
            path: addPrefix ? "/$path" : path,
            redirect: (context, state) =>
                redirectInjection?.call(context, state) ??
                redirect?.call(context, state),
            routes: _getSubRoutes(subPages),
            pageBuilder: builder != null
                ? (context, state) =>
                    NoTransitionPage(child: builder!(context, state))
                : null)
    ];
  }

  List<RouteBase> _getSubRoutes(List<BoringPage>? subPages) =>
      subPages
          ?.map((route) => route.getRoutes())
          .expand((element) => element)
          .toList() ??
      [];

  @override
  bool get isHiddenFromDrawer => hideFromDrawer;

  @override
  List<BoringPage> getPagesWithEmptyPath() {
    return path.isEmpty ? [this] : [];
  }
}
