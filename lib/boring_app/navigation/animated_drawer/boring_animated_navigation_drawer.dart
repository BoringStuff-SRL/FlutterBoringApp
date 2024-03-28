import 'dart:math';

import 'package:boring_app/boring_app.dart';
import 'package:flutter/material.dart';

import '../drawer/style/boring_drawer_style.dart';

part 'boring_drawer_expansion_animation.dart';

class BoringAnimatedNavigationDrawer<T> extends BoringNavigationDrawer<T> {
  final BoringAnimatedNavigationDrawerStyle animatedDrawerStyle;

  final ValueNotifier<bool> _mouseHoverNotifier = ValueNotifier(false);

  BoringAnimatedNavigationDrawer(
      {super.embraceAppBar = true,
      super.tileStyle,
      super.drawerHeaderBuilder,
      super.drawerFooterBuilder,
      super.drawerStyle = const BoringDrawerStyle(),
      this.animatedDrawerStyle = const BoringAnimatedNavigationDrawerStyle(),
      super.overrideDrawerStyle,
      super.rightPosition = false,
      super.appBarNotifier,
      super.appBarBuilder});

  @override
  Widget builder(
      BuildContext context,
      List<BoringNavigationGroupWithSelection> navigationGroups,
      BoxConstraints constraints) {
    final originalDrawer =
        super.builder(context, navigationGroups, constraints);

    final shrinkedDrawer = BoringNavigationDrawer<T>(
      shrinked: true,
      rightPosition: super.rightPosition,
      overrideDrawerStyle: super.overrideDrawerStyle,
      embraceAppBar: super.embraceAppBar,
      appBarBuilder: super.appBarBuilder,
      appBarNotifier: super.appBarNotifier,
      drawerFooterBuilder: super.drawerFooterBuilder,
      drawerHeaderBuilder: super.drawerHeaderBuilder,
      drawerStyle: super.drawerStyle.copyWith(
            width:
                super.drawerStyle.width * animatedDrawerStyle.shrinkPercentage,
          ),
      tileStyle: super.tileStyle,
    ).builder(context, navigationGroups, constraints);

    final BoringDrawerStyle overriddenDrawerStyle =
        overrideDrawerStyle?.call(drawerStyle, constraints) ?? drawerStyle;

    return MouseRegion(
      onEnter: (event) {
        _mouseHoverNotifier.value = true;
      },
      onExit: (event) {
        _mouseHoverNotifier.value = false;
      },
      child: ClipRRect(
        borderRadius: animatedDrawerStyle.shrinkedBorderRadius ??
            overriddenDrawerStyle.drawerRadius,
        child: ValueListenableBuilder(
          valueListenable: _mouseHoverNotifier,
          builder: (context, hover, child) => _BoringDrawerExpansionAnimation(
            style: animatedDrawerStyle,
            drawerStyle: drawerStyle,
            isShrinked: !hover,
            expandedDrawer: originalDrawer,
            shrinkedDrawer: shrinkedDrawer,
          ),
        ),
      ),
    );
  }
}
