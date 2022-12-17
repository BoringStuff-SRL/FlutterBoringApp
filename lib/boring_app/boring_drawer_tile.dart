import 'package:boring_app/boring_app/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/boring_expandable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringDrawerTile extends StatelessWidget {
  final BoringDrawerEntry entry;
  final Color? selectedColor;

  final String? path;

  factory BoringDrawerTile.selectFromPath(
      {required BoringDrawerEntry entry, String? path, Color? selectedColor}) {
    print("{$path} - {${entry.path}}");
    return BoringDrawerTile(
      entry: entry,
      selectedColor: selectedColor,
      path: path,
    );
  }

  const BoringDrawerTile({
    this.selectedColor,
    Key? key,
    required this.entry,
    this.path = "",
  }) : super(key: key);

  bool get isSelected => path == entry.path;

  Widget expansionTile(Function toggleExpansion, BuildContext context) {
    return ListTile(
      leading: entry.icon,
      title: Text(entry.label),
      textColor: isSelected ? (selectedColor ?? Colors.white) : null,
      iconColor: isSelected ? (selectedColor ?? Colors.white) : null,
      selectedColor: Colors.red,
      trailing: InkWell(
        borderRadius: BorderRadius.circular(24),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(Icons.expand_more),
        ),
        onTap: () => toggleExpansion(),
      ),
      hoverColor: isSelected ? Colors.transparent : null,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
      onTap: () => GoRouter.of(context).go(entry.path),
      //selected: isSelected,
    );
  }

  Widget tile(BuildContext context) {
    if (entry.subEntries == null || entry.subEntries!.isEmpty) {
      return ListTile(
        leading: entry.icon,
        title: Text(entry.label),
        textColor: isSelected ? (selectedColor ?? Colors.white) : null,
        iconColor: isSelected ? (selectedColor ?? Colors.white) : null,
        selectedColor: Colors.red,

        hoverColor: isSelected ? Colors.transparent : null,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
        onTap: () => GoRouter.of(context).go(entry.path),
        //selected: isSelected,
      );
    }

    return BoringExpandable(
        header: (toggleExpansion, animation) =>
            expansionTile(toggleExpansion, context),
        child: (toggleExpansion, animation) => Column(
              children: entry.subEntries!
                  .map((e) => BoringDrawerTile.selectFromPath(
                        entry: e,
                        path: path,
                      ))
                  .toList(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (!isSelected) return tile(context);
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Hero(
          tag: "tag",
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(12.0),
            ),
            child: SizedBox(
              height: 48,
              child: Container(
                  color: selectedColor ?? Theme.of(context).primaryColor),
            ),
          ),
        ),
        tile(context)
      ],
    );
  }
}
