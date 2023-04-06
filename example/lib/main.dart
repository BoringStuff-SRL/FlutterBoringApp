import 'package:boring_app/boring_app.dart';
import 'package:boring_app/boring_app/style/boring_drawer_tile_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
        BoringSection(
          drawerFooterBuilder: (context) {
            return GestureDetector(
              onTap: () {
                context.go('/hidden');
              },
              child: Text('Go to hidden'),
            );
          },
          drawerTileStyle: BoringDrawerTileStyle(
            selectedColor: Colors.red,
            selectedTextColor: Colors.pink,
            fontFamily: "Montserrat",
          ),
          children: [
            BoringPage(
              icon: Text("TEST"),
              drawerLabel: "Main",
              path: "main",
              builder: (context, state) {
                return HomePage();
              },
              showChildrenInDrawer: true,
              subPages: [
                BoringPage(
                  drawerLabel: "Settings",
                  path: "settings",
                  builder: (context, state) {
                    return HomePage();
                  },
                ),
                BoringPage(
                  path: "hidden",
                  drawerLabel: "Aaaa",
                  builder: (context, state) {
                    return Scaffold(
                      body: Column(
                        children: [
                          Text('This is the hidden page'),
                        ],
                      ),
                    );
                  },
                ),
              ]
            ),
            BoringPage(
              drawerLabel: "Settings",
              path: "settings",
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
