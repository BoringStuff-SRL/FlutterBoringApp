import 'dart:convert';
import 'dart:io';

import 'package:boring_app/boring_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(MyApp());
}

HttpClient client = HttpClient();

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

final ValueNotifier<String> testNotifier = ValueNotifier('pippo');

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BoringApp(
      initialLocation: "/1",
      functionsOnRouteObserved: [client.close],
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
        appBarNotifier: testNotifier,
        appBarBuilder:
            (context, state, navGroups, appBarNotifier, isDrawerVisible) {
          return AppBar(
            title: Text(appBarNotifier!.value),
          );
        },
      ),
      redirect: (context, state) {
        return null;
      },
      pages: [
        TestFirstPage(),
        TestSecondPage(),
      ],
    );
  }
}

class TestFirstPage extends BoringPage {
  static const String path = '/1';
  static const String label = 'Test 1';

  @override
  bool get hideFromNavigation => false;

  @override
  // TODO: implement subPages
  List<BoringPage> get subPages => [TestThirdPage()];

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testNotifier.value = 'TEST 1';
    });
    return SelectionArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FilledButton(
                  onPressed: () async {
                    //context.go('/1/3');

                    var url = Uri.parse(
                      'https://httpbin.org/delay/5',
                    );

                    client = HttpClient();

                     client.get('httpbin.org', 1010, 'delay/5');

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Container(
                        width: 150,
                        height: 150,
                        color: Colors.amber,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('back'),
                        ),
                      );
                    }));
                  },
                  child: const Text('GO TEST 3'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  BoringNavigationEntry get navigationEntry =>
      BoringNavigationEntry(path, label: label);
}

class TestSecondPage extends BoringPage {
  static const String path = '/2';
  static const String label = 'Test 2';

  @override
  bool get hideFromNavigation => false;

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testNotifier.value = 'TEST 2';
    });
    return const SelectionArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Placeholder(),
      ),
    );
  }

  @override
  BoringNavigationEntry get navigationEntry =>
      BoringNavigationEntry(path, label: label);
}

class TestThirdPage extends BoringPage {
  static const String path = ':id';
  static const String label = 'Test 3';

  @override
  bool get hideFromNavigation => false;

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testNotifier.value = 'TEST 1 > TEST 3';
    });
    return const SelectionArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Placeholder(),
      ),
    );
  }

  @override
  BoringNavigationEntry get navigationEntry =>
      BoringNavigationEntry(path, label: label);
}
