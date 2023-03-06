// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/style/boring_drawer_tile_style.dart';
import 'package:boring_app/boring_app/utils/boucing_animation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringDrawerEntry extends StatelessWidget {
  final String path;
  final String label;
  final Widget? icon;
  final List<BoringDrawerEntry>? subEntries;
  final BoringDrawerTileStyle tileStyle;

  final ValueNotifier<bool> _isHover = ValueNotifier(false);

  BoringDrawerEntry({
    super.key,
    required this.path,
    required this.label,
    this.tileStyle = const BoringDrawerTileStyle(),
    this.icon,
    this.subEntries,
  });

  bool get _hasSubentries => subEntries != null && subEntries!.isNotEmpty;

  bool checkIfSelected(BuildContext context) {
    final loc = GoRouter.of(context).location;
    return path == loc ||
        (!_hasSubentries && path != "/" && loc.contains(path));
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = checkIfSelected(context);

    if (selectedIndex) {
      _isHover.value = true;
    } else {
      _isHover.value = false;
    }
    return Column(
      children: [
        SizedBox(
          height: tileStyle.tileSpacing / 2,
        ),
        InkWell(
          onTap: () {
            GoRouter.of(context).go(path);
            Scaffold.of(context).closeDrawer();
          },
          onHover: (val) {
            if (!selectedIndex) {
              _isHover.value = val;
            }
          },
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: ValueListenableBuilder(
            valueListenable: _isHover,
            builder: (BuildContext context, bool value, Widget? child) {
              return CustomBounce(
                duration: const Duration(milliseconds: 150),
                onPressed: () {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  width: 220,
                  decoration: BoxDecoration(
                    color: value ? tileStyle.selectedColor : Colors.transparent,
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
                            fontWeight:
                                value ? FontWeight.w600 : FontWeight.w400),
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
