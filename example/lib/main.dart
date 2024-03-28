import 'package:boring_app/boring_app.dart';
import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_style.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
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
      boringNavigation: BoringNavigationDrawer(
        drawerStyle: BoringDrawerStyle(backgroundColor: Colors.red),
        appBarNotifier: testNotifier,
        appBarBuilder:
            (context, state, navGroups, appBarNotifier, isDrawerVisible) {
          return AppBar(
            title: Text(appBarNotifier!.value),
          );
        },
      ),
      redirect: (context, state) {
        testNotifier.value = '';
      },
      pages: [
        BoringPageWidget(
          navigationEntry: BoringNavigationEntry("/b",
              icon: const Icon(Icons.abc), label: 'ewqeqw'),
          subPages: [
            BoringPageWidget(
              hideFromNavigation: true,
              navigationEntry: BoringNavigationEntry('b', label: 'SIUU'),
              builder: (context, state) {
                print("BUILDING B SUBPAGE");
                return Text('asdasd');
              },
            )
          ],
          builder: (p0, p1) {
            print("BUILDING B");
            int index = 0;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              testNotifier.value = 'SIUUU';
            });
            return ElevatedButton(
              onPressed: () {
                testNotifier.value = '${++index}';
                p0.push('/b/b');
              },
              child: Text('signore'),
            );
          },
        ),
        BoringPageWidget(
          navigationEntry: BoringNavigationEntry("/a",
              icon: const Icon(Icons.abc), label: 'Prova123'),
          subPages: [
            BoringPageWidget(
              hideFromNavigation: true,
              navigationEntry: BoringNavigationEntry('b', label: 'SIUU'),
              builder: (context, state) => Text('asdasd'),
            )
          ],
          builder: (p0, p1) {
            print("BUILDING A");
            int index = 0;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              testNotifier.value = 'SIUUU';
            });
            return ElevatedButton(
              onPressed: () {
                testNotifier.value = '${++index}';
                p0.go('/a/b');
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
