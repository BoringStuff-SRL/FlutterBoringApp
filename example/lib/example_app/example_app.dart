import 'package:boring_app/boring_app/boring_app_section.dart';
import 'package:example/data/login.dart';
import 'package:flutter/material.dart';
import 'package:boring_app/boring_app/boring_app.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  final bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return BoringApp(
      sections: [
        BoringAppSection(
            exludeFromDrawer: true,
            redirect: (context, state) async =>
                (await Login.getLogin()) ? "/" : null,
            pages: [
              BoringAppPage(
                path: "/login",
                drawerLabel: "",
                pageBuilder: (context, state) => Center(
                  child: Scaffold(
                    body: Center(
                      child: ElevatedButton(
                          onPressed: () => Login.login(),
                          child: const Text("LOGIN")),
                    ),
                  ),
                ),
              )
            ]),
        BoringAppSection(
            redirect: (context, state) async =>
                (await Login.getLogin()) ? null : "/login",
            pages: [
              BoringAppPage(
                path: "/",
                drawerLabel: "Riepilogo",
                pageBuilder: (context, state) => Center(
                  child: ElevatedButton(
                      onPressed: () async => await Login.logout(),
                      child: Text("LOGOUT")),
                ),
              ),
              BoringAppPage(
                path: "/processings",
                drawerLabel: "Lavorazioni",
                pageBuilder: (context, state) => const Center(),
              ),
              BoringAppPage(
                path: "/deliveries",
                drawerLabel: "Consegne",
                pageBuilder: (context, state) => const Center(),
              ),
              BoringAppPage(
                path: "/items",
                drawerLabel: "Articoli",
                pageBuilder: (context, state) => const Center(),
              ),
              BoringAppPage(
                path: "/documents",
                drawerLabel: "Documenti",
                pageBuilder: (context, state) => const Center(),
              ),
              BoringAppPage(
                path: "/alerts",
                drawerLabel: "Avvisi",
                pageBuilder: (context, state) => const Center(),
              ),
              BoringAppPage(
                path: "/stats",
                drawerLabel: "Statistiche",
                pageBuilder: (context, state) => const Center(),
              ),
            ]),
        BoringAppSection(topDivider: true, pages: [
          BoringAppPage(
            path: "/customers",
            drawerLabel: "Clienti",
            pageBuilder: (context, state) => const Center(),
          ),
          BoringAppPage(
            path: "/forms",
            drawerLabel: "Form",
            pageBuilder: (context, state) => const Center(),
          ),
          BoringAppPage(
            path: "/tasks",
            drawerLabel: "Task",
            pageBuilder: (context, state) => const Center(),
          ),
        ])
      ],
    );
  }
}
