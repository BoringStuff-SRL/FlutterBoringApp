import 'package:boring_app/boring_app/boring_app.dart';
import 'package:boring_app/boring_app/navigation/drawer/boring_navigation_drawer.dart';
import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_style.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:boring_app/boring_app/pages/boring_page.dart';
import 'package:boring_app/boring_app/pages/boring_page_group.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ValueNotifier<String> testNotifier = ValueNotifier('pippo');

  @override
  Widget build(BuildContext context) {
    return BoringApp.withGroups(
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
      boringNavigation: BoringNavigationDrawer<String>(
        appBarNotifier: testNotifier,
        drawerStyle: const BoringDrawerStyle(
            width: 230,
            backgroundColor: Colors.white,
            drawerContentPadding: EdgeInsets.symmetric(horizontal: 25),
            drawerRadius: BorderRadius.all(Radius.circular(10))),
        appBarBuilder: (context, state, navGroups, notifier) {
          print('build appbar');
          return AppBar(
            backgroundColor: Colors.white,
            title: Text(
              notifier!.value,
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
      pageGroups: [
        BoringPageGroup(name: 'Vincenzo de simone', pages: [
          BoringPageWidget(
            navigationEntry:
                BoringNavigationEntry("/a", icon: const Icon(Icons.abc)),
            builder: (p0, p1) {
              print("BUILDING A");
              int index = 0;
              return ElevatedButton(
                onPressed: () {
                  testNotifier.value = '${++index}';
                },
                child: Text('signore'),
              );
            },
          ),
          BoringPageWidget(
            navigationEntry: BoringNavigationEntry("/b",
                label: "B", icon: const Icon(Icons.add_chart_sharp)),
            builder: (p0, p1) {
              return const Center(
                child: Text("B"),
              );
            },
          ),
          BoringPageWidget(
            navigationEntry: BoringNavigationEntry("/",
                label: "ROOT", icon: const Icon(Icons.add_chart_sharp)),
            builder: (p0, p1) {
              return const Center(
                child: Text("ROOT"),
              );
            },
          ),
          BoringPageWidget(
            hideFromNavigation: true,
            navigationEntry: BoringNavigationEntry("/c", label: "C"),
            builder: (p0, p1) {
              return const Center(
                child: Text("C"),
              );
            },
          ),
        ])
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
