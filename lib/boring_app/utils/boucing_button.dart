import 'dart:async';
import 'package:flutter/material.dart';

class DrawerBouncingButton extends StatelessWidget {
  DrawerBouncingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.animationDuration,
    this.scaling,
  });

  final ValueNotifier<bool> _isPressed = ValueNotifier<bool>(false);

  final Widget child;
  final FutureOr<void> Function() onPressed;
  final Duration? animationDuration;
  final double? scaling;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (details) {
          _isPressed.value = true;
        },
        onTapUp: (details) async {
          _isPressed.value = false;
          await onPressed.call();
        },
        child: ValueListenableBuilder(
          valueListenable: _isPressed,
          builder: (_, value, __) {
            return AnimatedScale(
              duration: animationDuration ?? const Duration(milliseconds: 150),
              scale: !value ? 1 : scaling ?? .85,
              curve: Curves.ease,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
