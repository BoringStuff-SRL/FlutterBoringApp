// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:boring_app/boring_app/pages/boring_page.dart';
import 'package:go_router/go_router.dart';

class BoringPageGroup {
  final String? name;
  final List<BoringPage> pages;
  const BoringPageGroup({
    this.name,
    required this.pages,
  });

  BoringNavigationGroup navigationGroup() {
    return BoringNavigationGroup(
        name: name,
        entries: pages.map((e) => e.navigationEntryWithSubentries()).toList());
  }

  List<RouteBase> get routes => pages.map((e) => e.route).toList();
}
