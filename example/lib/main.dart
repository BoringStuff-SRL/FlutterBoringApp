import 'package:boring_app/boring_app/boring_app.dart';
import 'package:boring_app/boring_app/navigation/drawer/boring_navigation_drawer.dart';
import 'package:boring_app/boring_app/navigation/navigation_entry.dart';
import 'package:boring_app/boring_app/pages/boring_page.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BoringApp(boringNavigation: BoringNavigationDrawer(), pages: [
      BoringPage(
          navigationEntry:
              BoringNavigationEntry("/a", icon: const Icon(Icons.abc)),
          builder: (p0, p1) {
            return const Center(
              child: Text("A"),
            );
          },
          subPages: [
            BoringPage(
              navigationEntry: BoringNavigationEntry("a1",
                  label: "A1", icon: const Icon(Icons.abc)),
              builder: (p0, p1) {
                return const Center(
                  child: Text("A1"),
                );
              },
            ),
            BoringPage(
              navigationEntry: BoringNavigationEntry("a2", label: "A2"),
              builder: (p0, p1) {
                return const Center(
                  child: Text("A2"),
                );
              },
            ),
            BoringPage(
              hideFromNavigation: true,
              giftSelectionWhenHidden: true,
              navigationEntry: BoringNavigationEntry("a3", label: "A3"),
              builder: (p0, p1) {
                return const Center(
                  child: Text("A3"),
                );
              },
            ),
          ]),
      BoringPage(
        navigationEntry: BoringNavigationEntry("/b",
            label: "B", icon: const Icon(Icons.add_chart_sharp)),
        builder: (p0, p1) {
          return const Center(
            child: Text("B"),
          );
        },
      ),
      BoringPage(
        hideFromNavigation: true,
        navigationEntry: BoringNavigationEntry("/c", label: "C"),
        builder: (p0, p1) {
          return const Center(
            child: Text("C"),
          );
        },
      ),
    ]);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
