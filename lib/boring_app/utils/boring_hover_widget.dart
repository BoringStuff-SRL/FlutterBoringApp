import 'package:flutter/material.dart';

class BoringHoverWidget extends StatelessWidget {
  BoringHoverWidget({
    required this.builder,
    super.key,
  });

  final ValueNotifier<bool> _isHover = ValueNotifier<bool>(false);

  final Widget Function(BuildContext context, bool isHover) builder;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (val) {
        _isHover.value = true;
      },
      onExit: (val) {
        _isHover.value = false;
      },
      opaque: false,
      child: ValueListenableBuilder(
        valueListenable: _isHover,
        builder: (BuildContext context, bool value, Widget? child) {
          return builder(context, value);
        },
      ),
    );
  }
}
