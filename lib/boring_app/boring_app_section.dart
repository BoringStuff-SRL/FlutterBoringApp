// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:js';

import 'package:boring_app/boring_app/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/boring_drawer_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringAppPage {
  String path;
  String drawerLabel;
  Icon? icon;
  Widget Function(BuildContext context, GoRouterState state)? pageBuilder;
  List<BoringAppPage> subPages;
  FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;

  BoringAppPage({
    required this.path,
    required this.drawerLabel,
    this.icon,
    this.redirect,
    this.pageBuilder,
    this.subPages = const [],
  });

  BoringDrawerEntry get drawerEntry => BoringDrawerEntry(drawerLabel,
      icon: icon,
      path: path,
      subEntries: subPages
          .map((e) => e.drawerEntry..path = path + "/" + e.drawerEntry.path)
          .toList());

  GoRoute route(
          [FutureOr<String?> Function(BuildContext, GoRouterState)?
              sectionRedirect]) =>
      GoRoute(
          path: path,
          routes: subPages.map((e) => e.route(sectionRedirect)).toList(),
          redirect: redirect ?? sectionRedirect,
          pageBuilder: pageBuilder != null
              ? ((context, state) =>
                  NoTransitionPage(child: pageBuilder!.call(context, state)))
              : null);
}

class BoringAppSection {
  List<BoringAppPage> pages;
  String? drawerTitle;
  bool collapsible;
  bool topDivider;
  bool exludeFromDrawer;
  BoringAppSection(
      {required this.pages,
      this.redirect,
      this.drawerTitle,
      this.exludeFromDrawer = false,
      this.collapsible = false,
      this.topDivider = false});

  FutureOr<String?> Function(BuildContext context, GoRouterState state)?
      redirect;
  List<GoRoute> get routes => pages.map((e) => e.route(redirect)).toList();

  BoringDrawerSection? get drawerSection => exludeFromDrawer
      ? null
      : BoringDrawerSection(
          title: drawerTitle,
          collapsible: collapsible,
          topDivider: topDivider,
          entries: pages.map((e) => e.drawerEntry).toList(),
        );
}
