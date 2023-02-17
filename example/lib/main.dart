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
