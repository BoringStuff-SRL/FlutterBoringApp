import 'dart:async';

import 'package:boring_app/boring_app.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class BoringPageBase {
  Widget? buildDrawerEntry(BuildContext context, [String fullPathPrefix]);
  bool get isHidden;
  List<GoRoute> getRoutes(
      {bool addPrefix = false,
      FutureOr<String?> Function(BuildContext context, GoRouterState state)?
          redirectInjection});
  List<BoringPage> getPagesWithEmptyPath();
}
