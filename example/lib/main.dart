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
    return BoringApp(
        boringNavigation: BoringNavigationDrawer(embraceAppBar: false),
        pages: [
          BoringPage(
              navigationEntry: BoringNavigationEntry("/a", label: "A"),
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
            navigationEntry: BoringNavigationEntry("/b", label: "B"),
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
    // return BoringApp(
    //   initialLocation: "/main",
    //   sections: [
    //     BoringAppSection(
    //       drawerFooterBuilder: (context) {
    //         return GestureDetector(
    //           onTap: () {
    //             context.go('/hidden');
    //           },
    //           child: Text('Go to hidden'),
    //         );
    //       },
    //       drawerTileStyle: BoringDrawerTileStyle(
    //         selectedColor: Colors.red,
    //         selectedTextColor: Colors.pink,
    //         fontFamily: "Montserrat",
    //       ),
    //       children: [
    //         BoringPage(
    //           icon: Text("TEST"),
    //           drawerLabel: "Main",
    //           path: "main",
    //           builder: (context, state) {
    //             return HomePage();
    //           },
    //           showChildrenInDrawer: true,
    //           subPages: [
    //             BoringPage(
    //               drawerLabel: "Settings",
    //               path: "settings",
    //               builder: (context, state) {
    //                 return HomePage();
    //               },
    //             ),
    //             BoringPage(
    //               path: "hidden",
    //               drawerLabel: "Aaaa",
    //               builder: (context, state) {
    //                 return Scaffold(
    //                   body: Column(
    //                     children: [
    //                       Text('This is the hidden page'),
    //                     ],
    //                   ),
    //                 );
    //               },
    //             ),
    //           ]
    //         ),
    //         BoringPage(
    //           drawerLabel: "Settings",
    //           path: "settings",
    //           builder: (context, state) {
    //             return HomePage();
    //           },
    //         ),
    //       ],
    //     )
    //   ],
    //   rootNavigator: GlobalKey<NavigatorState>(),
    // );
    return const Center();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
