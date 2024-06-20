import 'package:flutter/material.dart';

class BoringExpandable extends StatefulWidget {
  const BoringExpandable({
    required this.header,
    super.key,
    this.child,
    this.startExpanded = true,
  });

  final bool startExpanded;

  final Widget Function(Function toggleExpansion, Animation<double> animation)?
      child;

  final Widget Function(Function toggleExpansion, Animation<double> animation)
      header;

  @override
  State<BoringExpandable> createState() => _BoringExpandableState();
}

class _BoringExpandableState extends State<BoringExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  late Animation<double> rotatiionAnimation;

  void toggleAnimation() {
    // if (!widget.collapsible) {
    //   return;
    // }
    if (expandController.value == 0) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    //_runExpandCheck();
  }

  // void _runExpandCheck() {
  //   if (widget.initExpanded) {
  //     expandController.forward();
  //   } else {
  //     expandController.reverse();
  //   }
  // }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      value: widget.startExpanded ? 1 : 0,
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    rotatiionAnimation = Tween<double>(begin: 0, end: 0.5).animate(animation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header(toggleAnimation, animation),
        if (widget.child != null)
          SizeTransition(
            sizeFactor: animation,
            child: widget.child!(toggleAnimation, animation),
          ),
      ],
    );
  }
}
