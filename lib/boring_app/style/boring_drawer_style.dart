import 'package:flutter/material.dart';

class BoringDrawerStyle {
  final Color? backgroundColor;
  final BorderRadius drawerRadius;
  final EdgeInsets drawerContentPadding;
  final EdgeInsets drawerForeignPadding;
  final Widget drawerIcon;
  final double width;
  final double drawerElevation;

  const BoringDrawerStyle({
    this.backgroundColor,
    this.width = 250,
    this.drawerIcon = const Icon(Icons.menu),
    this.drawerForeignPadding = const EdgeInsets.all(20),
    this.drawerContentPadding = const EdgeInsets.all(16),
    this.drawerElevation = 0,
    this.drawerRadius = const BorderRadius.all(Radius.circular(20)),
  });
}
