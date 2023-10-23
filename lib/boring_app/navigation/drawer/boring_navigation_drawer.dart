// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_style.dart';
import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_tile_style.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';

class BoringNavigationDrawer<T> extends BoringNavigation<T> {
  final BoringDrawerStyle drawerStyle;
  final BoringDrawerStyle? Function(
          BoringDrawerStyle drawerStyle, BoxConstraints constraints)?
      overrideDrawerStyle;
  final BoringDrawerTileStyle? tileStyle;
  final Widget Function(BuildContext context)? drawerHeaderBuilder;
  final Widget Function(BuildContext context)? drawerFooterBuilder;
  BoringNavigationDrawer(
      {this.embraceAppBar = true,
      this.tileStyle,
      this.drawerHeaderBuilder,
      this.drawerFooterBuilder,
      this.drawerStyle = const BoringDrawerStyle(),
      this.overrideDrawerStyle,
      this.rightPosition = false,
      super.appBarNotifier,
      super.appBarBuilder});

  final bool rightPosition;

  @override
  BoringNavigationPosition get navigationPosition => rightPosition
      ? BoringNavigationPosition.right
      : BoringNavigationPosition.left;

  @override
  Widget builder(
      BuildContext context,
      List<BoringNavigationGroupWithSelection> navigationGroups,
      BoxConstraints constraints) {
    final children = navigationGroups
        .map((group) => group.entries.map((e) => e.toDrawerTile(
            context, tileStyle ?? const BoringDrawerTileStyle())))
        .expand((element) => element)
        .toList();
    final BoringDrawerStyle overriddenDrawerStyle =
        overrideDrawerStyle?.call(drawerStyle, constraints) ?? drawerStyle;
    return Drawer(
        width: overriddenDrawerStyle.width,
        shape: RoundedRectangleBorder(
            borderRadius: overriddenDrawerStyle.drawerRadius),
        elevation: overriddenDrawerStyle.drawerElevation,
        backgroundColor: overriddenDrawerStyle.backgroundColor,
        child: Column(
          children: [
            if (drawerHeaderBuilder != null) drawerHeaderBuilder!(context),
            Expanded(
              child: SingleChildScrollView(
                padding: overriddenDrawerStyle.drawerContentPadding,
                child: Column(children: children),
              ),
            ),
            if (drawerFooterBuilder != null) drawerFooterBuilder!(context),
          ],
        ));
  }

  @override
  final bool embraceAppBar;
}
