import 'package:flutter/cupertino.dart';

class BoringAnimatedNavigationDrawerStyle {
  final BorderRadius? shrinkedBorderRadius;
  final double shrinkPercentage;
  final Duration animationDuration;
  final List<Color> Function(double animation)? shadowColors;
  final List<double>? stops;

  const BoringAnimatedNavigationDrawerStyle({
    this.shrinkPercentage = .35,
    this.shrinkedBorderRadius,
    this.animationDuration = const Duration(milliseconds: 200),
    this.shadowColors,
    this.stops,
  });
}
