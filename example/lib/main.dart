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
      initialLocation: "/prima",
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
 develop
        drawerStyle: BoringDrawerStyle(backgroundColor: Colors.red),
        behaviour: BoringAnimatedNavigationDrawerBehaviour.toggleOnHover,
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
        return null;
      },
      pages: [
        BoringPageWidget(
          navigationEntry: BoringNavigationEntry("/prima",
              icon: const Icon(Icons.abc), label: 'Prima'),
          subPages: [
            BoringPageWidget(
              hideFromNavigation: true,
              navigationEntry: BoringNavigationEntry('seconda', label: 'SIUU'),
              builder: (context, state) {
                print("BUILDING SECOND PAGE");
                return ElevatedButton(
                    onPressed: () {
                      context.go("/prima1/seconda1");
                    },
                    child: const Text("VAI A SECONDA DENTRO SECONDA"));
              },
            ),
            BoringPageWidget(
              hideFromNavigation: true,
              navigationEntry: BoringNavigationEntry(':id/ciao', label: 'SIUU'),
              builder: (context, state) {
                print("BUILDING SECOND PAGE");
                final id = state.pathParameters["id"] ?? "NO ID";
                return Text("ID: $id");
              },
            )
          ],
          builder: (p0, p1) {
            print("BUILDING FIRST PAGE");

            return ElevatedButton(
              onPressed: () {
                p0.push('/prima/seconda');
              },
              child: const Text('VAI A SECONDA'),
            );
          },
        ),
        BoringPageWidget(
          navigationEntry: BoringNavigationEntry("/prima1",
              icon: const Icon(Icons.abc), label: 'Prima1'),
          subPages: [
            BoringPageWidget(
              hideFromNavigation: true,
              navigationEntry: BoringNavigationEntry('seconda1', label: 'SIUU'),
              builder: (context, state) {
                print("BUILDING SECOND PAGE");
                return const Text('SECONDA1');
              },
            )
          ],
          builder: (p0, p1) {
            print("BUILDING FIRST PAGE");

            return ElevatedButton(
              onPressed: () {
                p0.push('/prima1/seconda1');
              },
              child: const Text('VAI A SECONDA'),
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
