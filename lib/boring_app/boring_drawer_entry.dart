// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BoringDrawerEntry extends StatelessWidget {
  final String path;
  final String label;
  final Icon? icon;
  final List<BoringDrawerEntry>? subEntries;
  BoringDrawerEntry({
    super.key,
    required this.path,
    required this.label,
    this.icon,
    this.subEntries,
  });

  bool get _hasSubentries => subEntries != null && subEntries!.isNotEmpty;

  bool checkIfSelected(BuildContext context) {
    final loc = GoRouter.of(context).location;
    return path == loc ||
        (!_hasSubentries && path != "/" && loc.contains(path));
  }

  final Color selectedColor = Colors.green;
  late final Color textColor =
      selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  Widget tile(BuildContext context) {
    //if (entry.subEntries == null || entry.subEntries!.isEmpty) {
    final isSelected = checkIfSelected(context);
    return ListTile(
      leading: icon,
      title: Text(label),
      textColor: isSelected ? (textColor) : null,
      iconColor: isSelected ? (textColor) : null,
      hoverColor:
          isSelected ? Colors.transparent : selectedColor.withAlpha(150),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(12))),
      onTap: () => GoRouter.of(context).push(path),
      //selected: isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!checkIfSelected(context)) return tile(context);
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
              child: Container(color: selectedColor),
            ),
          ),
        ),
        tile(context)
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
