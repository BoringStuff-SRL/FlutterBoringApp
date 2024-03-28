part of 'boring_animated_navigation_drawer.dart';

class _BoringDrawerExpansionAnimation extends StatefulWidget {
  const _BoringDrawerExpansionAnimation({
    super.key,
    required this.style,
    required this.isShrinked,
    required this.child,
  });

  final BoringAnimatedNavigationDrawerStyle style;
  final bool isShrinked;
  final Widget child;

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
            begin: style.shrinkPercentage,
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _expansionAnimation,
      builder: (context, child) => Align(
        widthFactor: _expansionAnimation.value,
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            widget.child,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: style.stops ?? [0, .9],
                      colors:
                          style.shadowColors?.call(_expansionAnimation.value) ??
                              [
                                Colors.transparent,
                                Colors.black.withOpacity(
                                  1 - _expansionAnimation.value,
                                ),
                              ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
