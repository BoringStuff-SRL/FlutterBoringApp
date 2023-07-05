// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

enum SectionNavigator {
  drawer,
  navBar;
}

class BoringDrawerStyle {
  final Color? backgroundColor;
  final BorderRadius drawerRadius;
  final EdgeInsets drawerContentPadding;
  final EdgeInsets drawerForeignPadding;
  final Widget drawerIcon;
  final double width;
  final double drawerElevation;
  final SectionNavigator sectionNavigator;
  

  const BoringDrawerStyle({
    this.backgroundColor,
    this.width = 250,
    this.sectionNavigator = SectionNavigator.drawer,
    this.drawerIcon = const Icon(Icons.menu),
    this.drawerForeignPadding = const EdgeInsets.all(20),
    this.drawerContentPadding = const EdgeInsets.all(16),
    this.drawerElevation = 0,
    this.drawerRadius = const BorderRadius.all(Radius.circular(20)),
  });

  BoringDrawerStyle copyWith({
    Color? backgroundColor,
    BorderRadius? drawerRadius,
    EdgeInsets? drawerContentPadding,
    EdgeInsets? drawerForeignPadding,
    Widget? drawerIcon,
    double? width,
    double? drawerElevation,
    SectionNavigator? sectionNavigator,
  }) {
    return BoringDrawerStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        drawerRadius: drawerRadius ?? this.drawerRadius,
        drawerContentPadding: drawerContentPadding ?? this.drawerContentPadding,
        drawerForeignPadding: drawerForeignPadding ?? this.drawerForeignPadding,
        drawerIcon: drawerIcon ?? this.drawerIcon,
        width: width ?? this.width,
        drawerElevation: drawerElevation ?? this.drawerElevation,
        sectionNavigator: sectionNavigator ?? this.sectionNavigator);
  }
}
