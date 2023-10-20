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
      initialLocation: "/a",
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
              BoringDrawerStyle(sectionNavigator: SectionNavigator.drawer),
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
                drawerLabel: "A",
                path: "a",
                builder: (context, state) {
                  print('BUILD A');
                  return Column(
                    children: [
                      Text("A"),
                      ElevatedButton(
                          onPressed: () {
                            context.go('/a/a1');
                          },
                          child: Text('GO A1')),
                      ElevatedButton(
                          onPressed: () {
                            context.go('/b');
                          },
                          child: Text('GO B'))
                    ],
                  );
                },
                subPages: [
                  BoringPage(
                      icon: Icon(Icons.abc),
                      drawerLabel: "A1",
                      path: ":pippo",
                      builder: (context, state) {
                        print('BUILD A1 -> ${state.pathParameters['pippo']}');
                        return Text("A1");
                      },
                      subPages: [
                        BoringPage(
                          path: 'mezzo',
                          icon: Icon(Icons.abc),
                          drawerLabel: "A1",
                          builder: (context, state) {
                            print(
                                'BUILD MEZZO -> ${state.pathParameters['pippo']}');
                            return Text("MEZZO");
                          },
                          subPages: [
                            BoringPage(
                              icon: Icon(Icons.abc),
                              drawerLabel: "A2",
                              path: ":id",
                              builder: (context, state) {
                                print(
                                    'BUILD A2 -> ${state.pathParameters['id']} -> ${state.pathParameters['pippo']}');
                                return Text("A2");
                              },
                            )
                          ],
                        ),
                      ])
                ]),
            BoringPage(
              path: 'b',
              builder: (context, state) => Column(
                children: [
                  Text('B'),
                  ElevatedButton(
                      onPressed: () {
                        context.go('/a');
                      },
                      child: Text('GO A'))
                ],
              ),
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
