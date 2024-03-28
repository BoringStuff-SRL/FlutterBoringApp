part of 'boring_animated_navigation_drawer.dart';

class _BoringDrawerExpansionAnimation extends StatefulWidget {
  const _BoringDrawerExpansionAnimation({
    super.key,
    required this.style,
    required this.drawerStyle,
    required this.isShrinked,
    required this.expandedDrawer,
    required this.shrinkedDrawer,
  });

  final BoringAnimatedNavigationDrawerStyle style;
  final BoringDrawerStyle drawerStyle;
  final bool isShrinked;
  final Widget expandedDrawer;
  final Widget shrinkedDrawer;

  @override
  State<_BoringDrawerExpansionAnimation> createState() =>
      _BoringDrawerExpansionAnimationState();
}

class _BoringDrawerExpansionAnimationState
    extends State<_BoringDrawerExpansionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expansionAnimation;

  BoringAnimatedNavigationDrawerStyle get style => widget.style;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: style.animationDuration);

    _expansionAnimation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: Tween(
            begin: 0.0,
            end: 1.0,
          ),
          weight: 10,
        ),
      ],
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _BoringDrawerExpansionAnimation oldWidget) {
    if (oldWidget.isShrinked) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  double get smallWidgetOpacity => 1 - _expansionAnimation.value;
  double get bigWidgetOpacity => _expansionAnimation.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expansionAnimation,
      builder: (context, child) => Align(
        widthFactor: max(style.shrinkPercentage, _expansionAnimation.value),
        alignment: Alignment.centerLeft,
        child: Container(
          color: widget.drawerStyle.backgroundColor,
          child: Stack(
            children: [
              Opacity(
                opacity: bigWidgetOpacity,
                child: widget.expandedDrawer,
              ),
              IgnorePointer(
                ignoring: true,
                child: Opacity(
                  opacity: smallWidgetOpacity,
                  child: widget.shrinkedDrawer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
