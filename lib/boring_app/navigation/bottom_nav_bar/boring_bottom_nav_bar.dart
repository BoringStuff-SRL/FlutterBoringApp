// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/boring_navigation.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringBottomNavBar extends BoringNavigation {
  BoringBottomNavBar();

  @override
  BoringNavigationPosition get navigationPosition =>
      BoringNavigationPosition.bottom;

  @override
  Widget builder(
      BuildContext context,
      List<BoringNavigationGroupWithSelection> navigationGroups,
      BoxConstraints constraints) {
    final children = navigationGroups
        .map((group) => group.entries)
        .expand((element) => element)
        .toList();
    assert(
        children
            .every((element) => element.icon != null && element.label != null),
        "All BottomNavigationBar entries must have an icon and a label!");
    return BottomNavigationBar(
        onTap: (value) {
          GoRouter.of(context).go(children[value].path);
        },
        currentIndex: children.indexWhere((element) => element.selected),
        items: children
            .map((e) => BottomNavigationBarItem(icon: e.icon!, label: e.label!))
            .toList());

    // final children = navigationGroups
    //     .map((group) => group.entries.map((e) => e.toDrawerTile(
    //         context, tileStyle ?? const BoringDrawerTileStyle())))
    //     .expand((element) => element)
    //     .toList();
    // final BoringDrawerStyle overriddenDrawerStyle =
    //     overrideDrawerStyle?.call(drawerStyle, constraints) ?? drawerStyle;
    // return Drawer(
    //     width: overriddenDrawerStyle.width,
    //     shape: RoundedRectangleBorder(
    //         borderRadius: overriddenDrawerStyle.drawerRadius),
    //     elevation: overriddenDrawerStyle.drawerElevation,
    //     backgroundColor: overriddenDrawerStyle.backgroundColor,
    //     child: Column(
    //       children: [
    //         if (drawerHeaderBuilder != null) drawerHeaderBuilder!(context),
    //         Expanded(
    //           child: SingleChildScrollView(
    //             padding: overriddenDrawerStyle.drawerContentPadding,
    //             child: Column(children: children),
    //           ),
    //         ),
    //         if (drawerFooterBuilder != null) drawerFooterBuilder!(context),
    //       ],
    //     ));
  }

  @override
  final bool embraceAppBar = true;
}
