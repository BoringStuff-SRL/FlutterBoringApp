// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/style/boring_drawer_tile_style.dart';
import 'package:boring_app/boring_app/utils/boucing_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringDrawerEntry extends StatelessWidget {
  final String path;
  final String label;
  final Widget? icon;

  final List<BoringDrawerEntry>? subEntries;
  final BoringDrawerTileStyle tileStyle;

  final ValueNotifier<bool> _isHover = ValueNotifier(false);
  late ValueNotifier<bool> isExpanded;

  BoringDrawerEntry({
    super.key,
    required this.path,
    required this.label,
    this.tileStyle = const BoringDrawerTileStyle(),
    this.icon,
    this.subEntries,
  }) {
    isExpanded = ValueNotifier(tileStyle.tileInitiallyExpanded);
  }

  bool get _hasSubEntries => subEntries != null && subEntries!.isNotEmpty;

  bool checkIfSelected(BuildContext context) {
    final loc = GoRouter.of(context).location;
    return path == loc ||
        (!_hasSubEntries && path != "/" && loc.contains(path));
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = checkIfSelected(context);

    if (selectedIndex) {
      _isHover.value = true;
    } else {
      _isHover.value = false;
    }
    return _hasSubEntries
        ? ExpansionTile(
            onExpansionChanged: (value) => isExpanded.value = value,
            shape: tileStyle.tileShape ??
                const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
            tilePadding: tileStyle.tilePadding ??
                const EdgeInsets.symmetric(horizontal: 15),
            collapsedIconColor: tileStyle.unSelectedTextColor,
            collapsedTextColor: tileStyle.unSelectedTextColor,
            textColor: tileStyle.unSelectedTextColor,
            iconColor: tileStyle.unSelectedTextColor,
            collapsedBackgroundColor: tileStyle.backgroundColor,
            backgroundColor: tileStyle.backgroundColor,
            childrenPadding: tileStyle.tileChildrenPadding ??
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            trailing: Container(width: 1),
            initiallyExpanded: tileStyle.tileInitiallyExpanded,
            leading: ValueListenableBuilder(
              valueListenable: isExpanded,
              builder: (BuildContext context, bool value, Widget? child) {
                if (value) return tileStyle.isOpenedIcon;

                return tileStyle.isClosedIcon;
              },
            ),
            collapsedShape: tileStyle.tileShape ??
                const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
            title: Text(
              label,
              style: TextStyle(
                  color: tileStyle.unSelectedTextColor,
                  fontSize: tileStyle.fontSize,
                  fontFamily: tileStyle.fontFamily ??
                      Theme.of(context).textTheme.titleMedium?.fontFamily,
                  fontWeight: FontWeight.w500),
            ),
            children: List.generate(subEntries!.length, (i) => subEntries![i]),
          )
        : Column(
            children: [
              SizedBox(
                height: tileStyle.tileSpacing / 2,
              ),
              MouseRegion(
                onEnter: (val) {
                  if (!selectedIndex) {
                    _isHover.value = true;
                  }
                },
                onExit: (val) {
                  if (!selectedIndex) {
                    _isHover.value = false;
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: _isHover,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return DrawerBouncingButton(
                      onPressed: () {
                        GoRouter.of(context).go(path);
                        Scaffold.of(context).closeDrawer();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        width: 220,
                        decoration: BoxDecoration(
                          color: value
                              ? tileStyle.selectedColor
                              : Colors.transparent,
                          borderRadius: tileStyle.tileRadius,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null)
                              Row(
                                children: [
                                  ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          value
                                              ? tileStyle.selectedTextColor!
                                              : tileStyle.unSelectedTextColor!,
                                          BlendMode.srcIn),
                                      child: icon!),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            Text(
                              label,
                              style: TextStyle(
                                  color: value
                                      ? tileStyle.selectedTextColor
                                      : tileStyle.unSelectedTextColor,
                                  fontSize: tileStyle.fontSize,
                                  fontFamily: tileStyle.fontFamily ??
                                      Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.fontFamily,
                                  fontWeight: value
                                      ? FontWeight.w700
                                      : FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: tileStyle.tileSpacing / 2,
              )
            ],
          );
  }
}

// class BoringPageGroup implements BoringPageBase {
//   String title;
//   List<BoringPage> pages;
//   BoringPageGroup({
//     required this.title,
//     required this.pages,
//   });
//   @override
//   List<BoringEntry> get getDrawerEntries => pages
//       .map((e) => e.getDrawerEntries)
//       .expand((element) => element)
//       .toList();
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text("CIAO QUI"),
//     );
//   }
//   @override
//   List<GoRoute> getRoutes() {
//   }
// }
