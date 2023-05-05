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
  final Widget isOpenedIcon;
  final Widget isClosedIcon;
  final bool tileInitiallyExpanded;
  final ShapeBorder? tileShape;
  final EdgeInsets? tilePadding;
  final EdgeInsets? tileChildrenPadding;
  final Color? backgroundColor;

  const BoringDrawerTileStyle({
    this.tileRadius = const BorderRadius.all(
      Radius.circular(10.0),
    ),
    this.isOpenedIcon = const Icon(Icons.arrow_drop_up),
    this.isClosedIcon = const Icon(Icons.arrow_drop_down),
    this.tileSpacing = 8,
    this.selectedColor = Colors.green,
    this.selectedTextColor = Colors.black,
    this.unSelectedTextColor = Colors.grey,
    this.selectedIconColor,
    this.unSelectedIconColor,
    this.fontFamily,
    this.fontSize = 14,
    this.tileInitiallyExpanded = true,
    this.tileShape,
    this.tilePadding,
    this.tileChildrenPadding,
    this.backgroundColor,
  });
}
