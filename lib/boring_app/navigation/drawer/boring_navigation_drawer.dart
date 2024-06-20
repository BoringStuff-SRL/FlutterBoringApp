import 'package:boring_app/boring_app.dart';
import 'package:boring_app/boring_app/navigation/drawer/style/boring_drawer_style.dart';
import 'package:boringcore/widgets/boring_expandable/boring_expansion_widget.dart';
import 'package:flutter/material.dart';

part 'boring_drawer_expansion_animation.dart';

enum BoringAnimatedNavigationDrawerBehaviour {
  fixedOpen,
  fixedClose,
  toggleOnHover;

  bool get isMouseHover =>
      this == BoringAnimatedNavigationDrawerBehaviour.toggleOnHover;
}

class BoringNavigationDrawer<T> extends BoringNavigation<T> {
  BoringNavigationDrawer({
    this.embraceAppBar = true,
    this.tileStyle,
    this.animationDuration = const Duration(milliseconds: 200),
    this.drawerHeaderBuilder,
    this.drawerFooterBuilder,
    this.drawerStyle = const BoringDrawerStyle(),
    this.overrideDrawerStyle,
    this.rightPosition = false,
    super.appBarNotifier,
    super.appBarBuilder,
    this.behaviour = BoringAnimatedNavigationDrawerBehaviour.fixedOpen,
  });

  final Duration animationDuration;
  final BoringDrawerStyle drawerStyle;
  final BoringDrawerStyle? Function(
    BoringDrawerStyle drawerStyle,
    BoxConstraints constraints,
  )? overrideDrawerStyle;
  final BoringDrawerTileStyle? tileStyle;
  final Widget Function(BuildContext context, Animation<double>? animation)?
      drawerHeaderBuilder;
  final Widget Function(BuildContext context, Animation<double>? animation)?
      drawerFooterBuilder;

  final BoringAnimatedNavigationDrawerBehaviour behaviour;

  final bool rightPosition;

  @override
  BoringNavigationPosition get navigationPosition => rightPosition
      ? BoringNavigationPosition.right
      : BoringNavigationPosition.left;

  @override
  final bool embraceAppBar;

  @override
  Widget builder(
    BuildContext context,
    List<BoringNavigationGroupWithSelection> navigationGroups,
    BoxConstraints constraints,
  ) {
    return _BoringDrawerExpansionAnimation(
      behaviour: behaviour,
      animationDuration: animationDuration,
      constraints: constraints,
      navigationGroups: navigationGroups,
      drawerStyle: drawerStyle,
      tileStyle: tileStyle,
      appBarNotifier: appBarNotifier,
      appBarBuilder: appBarBuilder,
      drawerFooterBuilder: drawerFooterBuilder,
      drawerHeaderBuilder: drawerHeaderBuilder,
      embraceAppBar: embraceAppBar,
      overrideDrawerStyle: overrideDrawerStyle,
      rightPosition: rightPosition,
    );
  }
}
