// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app.dart';
import 'package:boring_app/boring_app/navigation/drawer/boring_drawer_entry.dart';
import 'package:flutter/material.dart';

class BoringNavigationEntry {
  final String path;
  final String? label;
  final Widget? icon;
  final BreadcrumbLabelBuilder? breadcrumbLabelBuilder;

  BoringNavigationEntry(
    this.path, {
    this.label,
    this.icon,
    this.breadcrumbLabelBuilder,
  });

  BoringNavigationEntry copyWithPath(String path) => BoringNavigationEntry(
        path,
        label: label,
        icon: icon,
        breadcrumbLabelBuilder: breadcrumbLabelBuilder,
      );
}

typedef BreadcrumbLabelBuilder = String Function(GoRouterState state);

class BoringNavigationEntryWithSubEntries extends BoringNavigationEntry {
  final bool hideInNav;
  final bool giftSelection;
  final List<BoringNavigationEntryWithSubEntries> subEntries;

  BoringNavigationEntryWithSubEntries(
    super.path, {
    required super.label,
    required super.breadcrumbLabelBuilder,
    required this.giftSelection,
    required this.hideInNav,
    super.icon,
    this.subEntries = const [],
  });

  factory BoringNavigationEntryWithSubEntries.from(
    BoringNavigationEntry navigationEntry,
    List<BoringNavigationEntryWithSubEntries> subEntries,
    bool hideInNav,
    bool giftSelection,
  ) =>
      BoringNavigationEntryWithSubEntries(
        navigationEntry.path,
        label: navigationEntry.label,
        icon: navigationEntry.icon,
        breadcrumbLabelBuilder: navigationEntry.breadcrumbLabelBuilder,
        subEntries: subEntries,
        giftSelection: giftSelection,
        hideInNav: hideInNav,
      );

  bool isSelected(GoRouterState state) => path == state.fullPath;
}

class BoringNavigationEntryWithSelection
    extends BoringNavigationEntryWithSubEntries {
  @override
  // ignore: overridden_fields
  final List<BoringNavigationEntryWithSelection> subEntries;

  final bool selected;

  BoringNavigationEntryWithSelection(
    super.path, {
    required super.label,
    required super.giftSelection,
    required super.hideInNav,
    required this.selected,
    super.icon,
    super.breadcrumbLabelBuilder,
    this.subEntries = const [],
  });

  factory BoringNavigationEntryWithSelection.from(
    BoringNavigationEntryWithSubEntries navigationEntry,
    GoRouterState state,
  ) {
    final subentries = navigationEntry.subEntries
        .map((e) => BoringNavigationEntryWithSelection.from(e, state))
        .toList();
    final inheritSelection =
        subentries.any((e) => e.selected && e.hideInNav && e.giftSelection);
    return BoringNavigationEntryWithSelection(
      navigationEntry.path,
      label: navigationEntry.label,
      icon: navigationEntry.icon,
      breadcrumbLabelBuilder: navigationEntry.breadcrumbLabelBuilder,
      hideInNav: navigationEntry.hideInNav,
      giftSelection: navigationEntry.giftSelection,
      subEntries: subentries,
      selected: inheritSelection || navigationEntry.isSelected(state),
    );
  }

  BoringDrawerEntry toDrawerTile(
    BuildContext context,
    BoringDrawerTileStyle tileStyle, {
    Animation<double>? hExpansionAnimation,
    bool overrideAlwaysOpen = false,
  }) =>
      BoringDrawerEntry(
        label: label,
        isSelected: selected,
        icon: icon,
        path: path,
        tileStyle: tileStyle,
        hExpansionAnimation: hExpansionAnimation,
        overrideAlwaysOpen: overrideAlwaysOpen,
        subEntries: subEntries
            .where((element) => !element.hideInNav)
            .map(
              (e) => e.toDrawerTile(
                context,
                tileStyle,
                hExpansionAnimation: hExpansionAnimation,
                overrideAlwaysOpen: overrideAlwaysOpen,
              ),
            )
            .toList(),
      );
}

class BoringNavigationGroup {
  String? name;
  Widget? icon;
  List<BoringNavigationEntryWithSubEntries> entries;

  BoringNavigationGroup({
    required this.entries,
    required this.icon,
    this.name,
  });
}

class BoringNavigationGroupWithSelection {
  String? name;
  Widget? icon;
  List<BoringNavigationEntryWithSelection> entries;

  BoringNavigationGroupWithSelection({
    required this.entries,
    this.name,
     this.icon,
  });

  bool get hasName => name != null && name!.isNotEmpty;

  factory BoringNavigationGroupWithSelection.from(
    BoringNavigationGroup navigationGroup,
    GoRouterState state,
  ) {
    return BoringNavigationGroupWithSelection(
      name: navigationGroup.name,
      icon: navigationGroup.icon,
      entries: navigationGroup.entries
          .where((element) => !element.hideInNav)
          .map((e) => BoringNavigationEntryWithSelection.from(e, state))
          .toList(),
    );
  }
}

extension WithSelection on List<BoringNavigationGroup> {
  List<BoringNavigationGroupWithSelection> withSelection(GoRouterState state) =>
      map((e) => BoringNavigationGroupWithSelection.from(e, state)).toList();
}
