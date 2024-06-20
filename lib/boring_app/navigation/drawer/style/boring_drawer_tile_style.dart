// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BoringDrawerTileStyle {
  final BorderRadius tileRadius;
  final double tileSpacing;
  final double tileMaxExpansion;
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
      Radius.circular(10),
    ),
    this.tileMaxExpansion = 150.0,
    this.isOpenedIcon = const Icon(Icons.arrow_drop_up),
    this.isClosedIcon = const Icon(Icons.arrow_drop_down),
    this.tileSpacing = 8,
    this.selectedColor = Colors.green,
    this.selectedTextColor = Colors.white,
    this.unSelectedTextColor = Colors.grey,
    this.selectedIconColor,
    this.unSelectedIconColor,
    this.fontFamily,
    this.fontSize = 14,
    this.tileInitiallyExpanded = true,
    this.tileShape,
    this.tilePadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.tileChildrenPadding,
    this.backgroundColor,
  });

  BoringDrawerTileStyle copyWith({
    BorderRadius? tileRadius,
    double? tileSpacing,
    Color? selectedColor,
    String? fontFamily,
    double? fontSize,
    Color? selectedTextColor,
    Color? unSelectedTextColor,
    Color? selectedIconColor,
    Color? unSelectedIconColor,
    Widget? isOpenedIcon,
    Widget? isClosedIcon,
    bool? tileInitiallyExpanded,
    ShapeBorder? tileShape,
    EdgeInsets? tilePadding,
    EdgeInsets? tileChildrenPadding,
    Color? backgroundColor,
  }) {
    return BoringDrawerTileStyle(
      tileRadius: tileRadius ?? this.tileRadius,
      tileSpacing: tileSpacing ?? this.tileSpacing,
      selectedColor: selectedColor ?? this.selectedColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      unSelectedTextColor: unSelectedTextColor ?? this.unSelectedTextColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      unSelectedIconColor: unSelectedIconColor ?? this.unSelectedIconColor,
      isOpenedIcon: isOpenedIcon ?? this.isOpenedIcon,
      isClosedIcon: isClosedIcon ?? this.isClosedIcon,
      tileInitiallyExpanded:
          tileInitiallyExpanded ?? this.tileInitiallyExpanded,
      tileShape: tileShape ?? this.tileShape,
      tilePadding: tilePadding ?? this.tilePadding,
      tileChildrenPadding: tileChildrenPadding ?? this.tileChildrenPadding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
