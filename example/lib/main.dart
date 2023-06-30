import 'package:boring_app/boring_app.dart';
import 'package:boring_app/boring_app/boring_app.dart';
import 'package:boring_app/boring_app/style/boring_drawer_tile_style.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BoringApp(
      initialLocation: "/main",
      sections: [
        BoringAppSection(
          drawerFooterBuilder: (context) {
            return GestureDetector(
              onTap: () {
                context.go('/hidden');
              },
              child: Text('Go to hidden'),
            );
          },
          drawerStyle:
              BoringDrawerStyle(sectionNavigator: SectionNavigator.navBar),
          drawerTileStyle: BoringDrawerTileStyle(
            selectedColor: Colors.transparent,
            selectedTextColor: Colors.pink,
            fontFamily: "Montserrat",
            isClosedIcon: Icon(Icons.abc),
            isOpenedIcon: Icon(Icons.ac_unit_outlined),
            tileInitiallyExpanded: true,
          ),
          children: [
            BoringPage(
              icon: Icon(Icons.abc),
              drawerLabel: "Main",
              path: "main",
              builder: (context, state) {
                return Placeholder(
                  color: Colors.red,
                );
              },
            ),
            BoringPage(
              drawerLabel: "Settings",
              path: "settings",
              icon: Icon(Icons.question_answer),
              builder: (context, state) {
                return HomePage();
              },
            ),
          ],
        )
      ],
      rootNavigator: GlobalKey<NavigatorState>(),
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
