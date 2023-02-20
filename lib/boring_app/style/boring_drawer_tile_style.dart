import 'package:flutter/material.dart';

class BoringDrawerTileStyle {
  final BorderRadius tileRadius;
  final double tileSpacing;
  final Color selectedColor;
  final String? fontFamily;
  final double? fontSize;
  final Color? selectedTextColor;
  final Color? unSelectedTextColor;
  final Color? selectedIconColor;
  final Color? unSelectedIconColor;

  const BoringDrawerTileStyle({
    this.tileRadius = const BorderRadius.all(
      Radius.circular(10.0),
    ),
    this.tileSpacing = 8,
    this.selectedColor = Colors.green,
    this.selectedTextColor = Colors.black,
    this.unSelectedTextColor = Colors.grey,
    this.selectedIconColor,
    this.unSelectedIconColor,
    this.fontFamily,
    this.fontSize = 14,
  });
}
