import 'dart:async';

import 'package:boring_app/boring_app/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/boring_page/boring_page_base.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export 'package:boring_app/boring_app/boring_page/boring_page_base.dart';

class BoringPage implements BoringPageBase {
  String path;
  String drawerLabel;
  Icon? icon;
  List<BoringPage>? subPages;
  bool hideFromDrawer;
  bool showChildrenInDrawer;
  Widget Function(BuildContext, GoRouterState)? builder;
  FutureOr<String?> Function(BuildContext, GoRouterState)? redirect;

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

  List<BoringDrawerEntry>? _subDrawerEntries(String fullPathPrefix) =>
      showChildrenInDrawer
          ? subPages
              ?.map((e) => e.boringDrawerEntry(fullPathPrefix))
              .where((element) => element != null)
              .toList() as List<BoringDrawerEntry>
          : null;

  BoringDrawerEntry? boringDrawerEntry(String fullPathPrefix) => !hideFromDrawer
      ? BoringDrawerEntry(
          path: "$fullPathPrefix/$path",
          label: drawerLabel,
          subEntries: _subDrawerEntries("$fullPathPrefix/$path"),
          icon: icon)
      : null;

  // @override
  // List<BoringEntry> get getDrawerEntries =>
  //     !hideFromDrawer ? [_boringEntry as BoringEntry] : [];

  @override
  Widget? buildDrawerEntry(BuildContext context, [String fullPathPrefix = ""]) {
    return boringDrawerEntry(fullPathPrefix);
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
            pageBuilder: builder != null
                ? (context, state) =>
                    NoTransitionPage(child: builder!(context, state))
                : null)
    ];
  }

  @override
  bool get isHidden => hideFromDrawer;

  @override
  List<BoringPage> getPagesWithEmptyPath() {
    return path.isEmpty ? [this] : [];
  }
}
