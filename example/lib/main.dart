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
      initialLocation: "/test",
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
        drawerStyle: const BoringDrawerStyle(backgroundColor: Colors.red),
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
      pages: [MyPage()],
    );
  }
}

class MyPage extends BoringPage {
  @override
  Map<String, String> get initialQueryParams => {
        'page': "1",
      };

  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0.5,
          )
        ],
      ),
      child: FilledButton(
          onPressed: () {
            context.go('/test/subpage');
          },
          child: Text('child')),
    );
  }

  @override
  // TODO: implement subPages
  List<BoringPage> get subPages => [MySubPage()];
  @override
  BoringNavigationEntry get navigationEntry =>
      BoringNavigationEntry('/test', label: 'Test');
}

class MySubPage extends BoringPage {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.red,
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset.zero,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  @override
  BoringNavigationEntry get navigationEntry =>
      BoringNavigationEntry('subpage', label: 'Test');
}
