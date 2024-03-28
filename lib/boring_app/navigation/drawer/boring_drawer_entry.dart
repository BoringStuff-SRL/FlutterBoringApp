// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_tile_style.dart';
import 'package:boring_app/boring_app/utils/boring_expandable.dart';
import 'package:boring_app/boring_app/utils/boring_hover_widget.dart';
import 'package:boring_app/boring_app/utils/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringDrawerEntry extends StatelessWidget {
  final String path;
  final String? label;
  final Widget? icon;
  final bool isSelected;
  final List<BoringDrawerEntry> subEntries;
  final BoringDrawerTileStyle tileStyle;
  final bool shrinked;

  late final ValueNotifier<bool> isExpanded;

  BoringDrawerEntry({
    super.key,
    required this.path,
    this.label,
    this.icon,
    required this.isSelected,
    this.tileStyle = const BoringDrawerTileStyle(),
    required this.subEntries,
    this.shrinked = false,
  }) {
    if (shrinked) {
      assert(icon != null,
          "If you want the Drawer to be shrinked, please provide an icon for this tile");
    }
    isExpanded = ValueNotifier(false);
  }

  bool get _hasSubEntries => subEntries.isNotEmpty;

  Widget _tileHeader(Function toggleExpansion, Animation<double> animation) =>
      Padding(
        padding: EdgeInsets.symmetric(
          vertical: tileStyle.tileSpacing / 2,
        ),
        child: BoringHoverWidget(
          builder: (context, isHover) => BoringBouncingButton(
            onPressed: () {
              final currentPath = GoRouter.of(context)
                  .routeInformationProvider
                  .value
                  .uri
                  .toString();

              if (currentPath != path) {
                GoRouter.of(context).go(path);
              }
              Scaffold.of(context).closeDrawer();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: tileStyle
                  .tilePadding, //const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: (isHover || isSelected)
                    ? tileStyle.selectedColor
                    : Colors.transparent,
                borderRadius: tileStyle.tileRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Padding(
                      padding: shrinked
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(right: 8.0),
                      child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              (isHover || isSelected)
                                  ? tileStyle.selectedTextColor!
                                  : tileStyle.unSelectedTextColor!,
                              BlendMode.srcIn),
                          child: icon!),
                    ),
                  if (!shrinked)
                    Expanded(
                      child: Text(
                        label ?? "",
                        style: TextStyle(
                            color: (isHover || isSelected)
                                ? tileStyle.selectedTextColor
                                : tileStyle.unSelectedTextColor,
                            fontSize: tileStyle.fontSize,
                            fontFamily: tileStyle.fontFamily ??
                                Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.fontFamily,
                            fontWeight: (isHover || isSelected)
                                ? FontWeight.w700
                                : FontWeight.w500),
                      ),
                    ),
                  if (_hasSubEntries && !shrinked)
                    AnimatedBuilder(
                        animation: animation,
                        child: InkWell(
                          child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  (isHover || isSelected)
                                      ? tileStyle.selectedTextColor!
                                      : tileStyle.unSelectedTextColor!,
                                  BlendMode.srcIn),
                              child: const Icon(Icons.expand_more)),
                          onTap: () => toggleExpansion(),
                        ),
                        builder: (context, child) => Transform.rotate(
                              angle: animation.value *
                                  pi, // This is the current rotation value
                              child: child, // Your widget goes here
                            ))
                ],
              ),
            ),
          ),
        ),
      );

//IconButton(
  // onPressed: () => toggleExpansion(),
  // icon: const Icon(Icons.expand_more))

  @override
  Widget build(BuildContext context) {
    return BoringExpandable(
      child: (subEntries.isNotEmpty)
          ? (toggleExpansion, animation) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  children: subEntries,
                ),
              );
            }
          : null,
      header: (toggleExpansion, animation) {
        return _tileHeader(toggleExpansion, animation);
      },
    );
  }
}
