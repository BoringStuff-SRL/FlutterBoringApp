import 'dart:async';

import 'package:boring_app/boring_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../style/boring_drawer_tile_style.dart';

abstract class BoringPageBase {
  Widget? buildDrawerEntry(
      BuildContext context, BoringDrawerTileStyle tileStyle,
      [String fullPathPrefix]);

  bool get isHiddenFromDrawer;

  List<GoRoute> getRoutes(
      {bool addPrefix = false,
      FutureOr<String?> Function(BuildContext context, GoRouterState state)?
          redirectInjection});

  List<BoringPage> getPagesWithEmptyPath();
}
