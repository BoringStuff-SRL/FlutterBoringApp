import 'package:boring_app/boring_app/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/boring_drawer_tile.dart';
import 'package:boring_app/boring_app/boring_expandable.dart';
import 'package:flutter/material.dart';

class BoringDrawerSection extends StatelessWidget {
  const BoringDrawerSection({
    super.key,
    this.title,
    this.collapsible = false,
    required this.entries,
    this.path,
    this.topDivider = false,
  });

  BoringDrawerSection copyWith(String? path) => BoringDrawerSection(
        entries: entries,
        title: title,
        collapsible: collapsible,
        topDivider: topDivider,
        path: path,
      );

  final String? title;
  final bool collapsible;
  final List<BoringDrawerEntry> entries;
  final String? path;
  final bool topDivider;

  sectionEntries(BuildContext context, String? path) => Column(
        children: entries
            .map((e) => BoringDrawerTile.selectFromPath(entry: e, path: path))
            .toList(),
      );

  bool renderExpandable() =>
      (title != null && title!.isNotEmpty) || collapsible;

  Widget child(BuildContext context) {
    if (renderExpandable()) {
      return BoringExpandable(
          header: (toggleExpansion, animation) => InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                onTap: toggleExpansion,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        overflow: TextOverflow.ellipsis,
                        title ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.grey),
                      )),
                      Icon(Icons.expand_more)
                    ],
                  ),
                ),
              ),
          child: (toggleExpansion, animation) => sectionEntries(context, path));
    }
    return sectionEntries(context, path);
  }

  @override
  Widget build(BuildContext context) {
    if (topDivider) {
      return Column(
        children: [const Divider(), child(context)],
      );
    }
    return child(context);
  }
}
