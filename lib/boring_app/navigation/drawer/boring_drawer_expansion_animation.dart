part of 'boring_navigation_drawer.dart';

class _BoringDrawerExpansionAnimation<T> extends StatefulWidget {
  final BoringDrawerStyle drawerStyle;
  final BoringDrawerStyle? Function(
          BoringDrawerStyle drawerStyle, BoxConstraints constraints)?
      overrideDrawerStyle;
  final BoringDrawerTileStyle? tileStyle;
  final Widget Function(BuildContext context, Animation<double> animation)?
      drawerHeaderBuilder;
  final Widget Function(BuildContext context, Animation<double> animation)?
      drawerFooterBuilder;
  final bool embraceAppBar;
  final bool rightPosition;
  final Duration animationDuration;
  final BoringAnimatedNavigationDrawerBehaviour behaviour;

  final ValueNotifier<T>? appBarNotifier;
  final AppBar? Function(
      BuildContext context,
      GoRouterState state,
      List<BoringNavigationGroupWithSelection> navGroups,
      ValueNotifier<T>? appBarNotifier,
      bool isDrawerVisible)? appBarBuilder;

  final List<BoringNavigationGroupWithSelection> navigationGroups;
  final BoxConstraints constraints;

  const _BoringDrawerExpansionAnimation({
    this.embraceAppBar = true,
    this.tileStyle,
    this.drawerHeaderBuilder,
    this.drawerFooterBuilder,
    this.drawerStyle = const BoringDrawerStyle(),
    this.overrideDrawerStyle,
    this.rightPosition = false,
    this.appBarNotifier,
    this.appBarBuilder,
    required this.behaviour,
    required this.navigationGroups,
    required this.constraints,
    required this.animationDuration,
  });

  @override
  State<_BoringDrawerExpansionAnimation> createState() =>
      _BoringDrawerExpansionAnimationState();
}

class _BoringDrawerExpansionAnimationState
    extends State<_BoringDrawerExpansionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    switch (widget.behaviour) {
      case BoringAnimatedNavigationDrawerBehaviour.fixedOpen:
        _animationController.value = 1.0;
        break;
      default:
    }
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleAnimation() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (var group in widget.navigationGroups) {
      final childrenWidgets = group.entries.map((e) {
        return e.toDrawerTile(
          context,
          widget.tileStyle ?? const BoringDrawerTileStyle(),
          hExpansionAnimation: _animationController,
        );
      }).toList();

      if (group.hasName) {
        children.add(
          BoringExpansionWidget(
            tilePadding: const EdgeInsets.all(8),
            childPadding: EdgeInsets.zero,
            primary: Text(group.name!),
            disabledTextColor: widget.drawerStyle.groupTileDisabledColor,
            disabledIconColor: widget.drawerStyle.groupTileDisabledColor,
            child: Column(
              children: childrenWidgets,
            ),
          ),
        );
      } else {
        children.addAll(childrenWidgets);
      }
    }
    final BoringDrawerStyle overriddenDrawerStyle = widget.overrideDrawerStyle
            ?.call(widget.drawerStyle, widget.constraints) ??
        widget.drawerStyle;
    return MouseRegion(
      onEnter: (event) {
        if (widget.behaviour.isMouseHover) toggleAnimation();
      },
      onExit: (event) {
        if (widget.behaviour.isMouseHover) toggleAnimation();
      },
      child: Container(
        decoration: BoxDecoration(
            color: overriddenDrawerStyle.backgroundColor,
            borderRadius: overriddenDrawerStyle.drawerRadius),
        child: Column(
          children: [
            if (widget.drawerHeaderBuilder != null)
              widget.drawerHeaderBuilder!(context, _animationController),
            Expanded(
              child: SingleChildScrollView(
                padding: overriddenDrawerStyle.drawerContentPadding,
                child: Column(children: children),
              ),
            ),
            if (widget.drawerFooterBuilder != null)
              widget.drawerFooterBuilder!(context, _animationController),
          ],
        ),
      ),
    );
  }
}
