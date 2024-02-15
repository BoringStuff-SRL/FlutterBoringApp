import 'package:boring_app/boring_app.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class BoringTopNavigation<T> extends BoringNavigation<T> {
  BoringTopNavigation({super.appBarNotifier, super.appBarBuilder});

  @override
  Widget builder(
      BuildContext context,
      List<BoringNavigationGroupWithSelection> navigationGroups,
      BoxConstraints constraints) {
    final children = <Widget>[];

    for (final group in navigationGroups) {
      final childrenWidgets = group.entries
          .map((e) => e.toDrawerTile(context, const BoringDrawerTileStyle()))
          .toList();

      children.addAll(childrenWidgets);
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          children: [Text("ASD")],
        ),
      ),
    );
  }

  @override
  bool get embraceAppBar => true;

  @override
  BoringNavigationPosition get navigationPosition =>
      BoringNavigationPosition.top;
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<String> testNotifier = ValueNotifier('pippo');

  @override
  Widget build(BuildContext context) {
    return BoringApp(
      initialLocation: "/a",
      themeConfig: BoringThemeConfig(
          theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: false,
        visualDensity: VisualDensity.standard,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
        primaryColor: Colors.green,
        timePickerTheme: const TimePickerThemeData(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
      )),
      boringNavigation: BoringTopNavigation(),
      pages: [
        BoringPageWidget(
          navigationEntry:
              BoringNavigationEntry("/a", icon: const Icon(Icons.abc)),
          builder: (p0, p1) {
            print("BUILDING A");
            int index = 0;
            return ElevatedButton(
              onPressed: () {
                testNotifier.value = '${++index}';
                p0.go('/a/12');
              },
              child: Text('signore'),
            );
          },
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
