// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/drawer/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_tile_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringNavigationEntry {
  final String path;
  final String? label;
  final Widget? icon;
  BoringNavigationEntry(
    this.path, {
    this.label,
    this.icon,
  });
  BoringNavigationEntry copyWithPath(String path) =>
      BoringNavigationEntry(path, label: label, icon: icon);
}

class BoringNavigationEntryWithSubEntries {
  final String path;
  final String? label;
  final Widget? icon;
  final bool hideInNav;
  final bool giftSelection;
  final List<BoringNavigationEntryWithSubEntries> subEntries;
  BoringNavigationEntryWithSubEntries(
    this.path, {
    this.subEntries = const [],
    required this.label,
    this.icon,
    required this.giftSelection,
    required this.hideInNav,
  });

  factory BoringNavigationEntryWithSubEntries.from(
          BoringNavigationEntry navigationEntry,
          List<BoringNavigationEntryWithSubEntries> subEntries,
          bool hideInNav,
          bool giftSelection) =>
      BoringNavigationEntryWithSubEntries(navigationEntry.path,
          label: navigationEntry.label,
          hideInNav: hideInNav,
          icon: navigationEntry.icon,
          giftSelection: giftSelection,
          subEntries: subEntries);

  bool isSelected(GoRouterState state) => path == state.fullPath;
}

class BoringNavigationEntryWithSelection {
  final String path;
  final String? label;
  final Widget? icon;
  final bool selected;
  final bool hideInNav;
  final bool giftSelection;
  final List<BoringNavigationEntryWithSelection> subEntries;
  BoringNavigationEntryWithSelection(
    this.path, {
    required this.hideInNav,
    required this.giftSelection,
    this.subEntries = const [],
    required this.label,
    this.icon,
    required this.selected,
  });

  factory BoringNavigationEntryWithSelection.from(
      BoringNavigationEntryWithSubEntries navigationEntry,
      GoRouterState state) {
    final subentries = navigationEntry.subEntries
        .map((e) => BoringNavigationEntryWithSelection.from(e, state))
        .toList();
    // print(
    //     "CURRENT PATH ${navigationEntry.path} - HIDDEN : ${navigationEntry.hideInNav}");
    final inheritSelection =
        subentries.any((e) => e.selected && e.hideInNav && e.giftSelection);
    return BoringNavigationEntryWithSelection(navigationEntry.path,
        label: navigationEntry.label,
        icon: navigationEntry.icon,
        hideInNav: navigationEntry.hideInNav,
        giftSelection: navigationEntry.giftSelection,
        subEntries: subentries,
        selected: inheritSelection || navigationEntry.isSelected(state));
  }

  BoringDrawerEntry toDrawerTile(
    BuildContext context,
    BoringDrawerTileStyle tileStyle, {
    Animation<double>? hExpansionAnimation,
  }) =>
      BoringDrawerEntry(
        label: label,
        isSelected: selected,
        icon: icon,
        path: path,
        tileStyle: tileStyle,
        hExpansionAnimation: hExpansionAnimation,
        subEntries: subEntries
            .where((element) => !element.hideInNav)
            .map((e) => e.toDrawerTile(context, tileStyle,
                hExpansionAnimation: hExpansionAnimation))
            .toList(),
      );
}

class BoringNavigationGroup {
  String? name;
  List<BoringNavigationEntryWithSubEntries> entries;
  BoringNavigationGroup({
    this.name,
    required this.entries,
  });
}

class BoringNavigationGroupWithSelection {
  String? name;
  List<BoringNavigationEntryWithSelection> entries;
  BoringNavigationGroupWithSelection({
    this.name,
    required this.entries,
  });

  bool get hasName => name != null && name!.isNotEmpty;

  factory BoringNavigationGroupWithSelection.from(
      BoringNavigationGroup navigationGroup, GoRouterState state) {
    return BoringNavigationGroupWithSelection(
        name: navigationGroup.name,
        entries: navigationGroup.entries
            .where((element) => !element.hideInNav)
            .map((e) => BoringNavigationEntryWithSelection.from(e, state))
            .toList());
  }
}

extension WithSelection on List<BoringNavigationGroup> {
  List<BoringNavigationGroupWithSelection> withSelection(GoRouterState state) =>
      map((e) => BoringNavigationGroupWithSelection.from(e, state)).toList();
}
