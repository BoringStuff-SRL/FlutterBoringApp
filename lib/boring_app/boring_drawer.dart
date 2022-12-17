// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_app/boring_app/boring_drawer_section.dart';
import 'package:boring_app/boring_app/boring_drawer_entry.dart';
import 'package:boring_app/boring_app/boring_drawer_section.dart';
import 'package:boring_app/boring_app/boring_expandable.dart';
import 'package:flutter/material.dart';

import 'boring_drawer_tile.dart';

class BoringDrawer extends StatelessWidget {
  const BoringDrawer(
      {super.key,
      this.path,
      required this.sections,
      this.footerBuilder,
      this.headerBuilder});

  final String? path;
  final List<BoringDrawerSection> sections;
  final Widget Function(BuildContext context)? headerBuilder;
  final Widget Function(BuildContext context)? footerBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 20,
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              if (headerBuilder != null) headerBuilder!(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: sections
                        .map((section) => section.copyWith(path))
                        .toList(),
                  ),
                ),
              ),
              if (footerBuilder != null) footerBuilder!(context),
            ],
          ),
        ),
      ),
    );
  }
}
