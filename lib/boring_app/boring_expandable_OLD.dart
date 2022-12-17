import 'package:flutter/material.dart';

class BoringExpandable extends StatefulWidget {
  const BoringExpandable(
      {super.key,
      required this.child,
      this.leadingIcon = Icons.expand_more,
      this.expandOnHeaderTap = false,
      this.collapsible = true,
      this.title,
      this.textStyle,
      this.initExpanded = true,
      this.headerPadding = const EdgeInsets.all(8.0),
      this.bottomDividerOnExpanded = false,
      this.headerBorderRadius,
      this.lineAfterText = false,
      this.headerColor,
      this.customHeader,
      this.onHeaderTap})
      : assert(expandOnHeaderTap == false || onHeaderTap == null,
            "You can either provide a onHeaderTap callback or toggle the expansion on headerTap"),
        assert(!expandOnHeaderTap || collapsible,
            "You can't expandOnHeaderTap if the ExpansionCart is not collapsible");

  final bool initExpanded;
  final IconData? leadingIcon;
  final bool expandOnHeaderTap;
  final void Function()? onHeaderTap;
  final bool collapsible;
  final EdgeInsetsGeometry headerPadding;
  final String? title;
  final TextStyle? textStyle;
  final Widget child;
  final bool bottomDividerOnExpanded;
  final BorderRadius? headerBorderRadius;
  final bool lineAfterText;
  final Color? headerColor;
  final Widget Function(Function toggleExpansion)? customHeader;
  //TODO add expansion on specific constraints

  @override
  State<BoringExpandable> createState() => _BoringExpandableState();
}

class _BoringExpandableState extends State<BoringExpandable>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  late Animation<double> rotatiionAnimation;

  void toggleVisibility() {
    if (!widget.collapsible) {
      return;
    }
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
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (widget.initExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    rotatiionAnimation = Tween<double>(begin: 0, end: 0.5).animate(animation);
  }

  Widget _headerTitle() {
    return Text(
      overflow: TextOverflow.ellipsis,
      widget.title ?? "",
      style: (widget.textStyle ?? Theme.of(context).textTheme.headline5)
          ?.copyWith(color: widget.headerColor),
    );
  }

  Widget? _headerIcon() {
    if (widget.leadingIcon == null) {
      return null;
    }
    Widget trailingWidget = RotationTransition(
        turns: rotatiionAnimation,
        child: Icon(
          widget.leadingIcon,
          color: widget.headerColor,
        ));
    if (widget.expandOnHeaderTap || !widget.collapsible) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: trailingWidget,
      );
    }
    return IconButton(
      onPressed: toggleVisibility,
      icon: trailingWidget,
      color: widget.headerColor,
    );
  }

  Widget _header() {
    if (widget.customHeader != null) {
      print("HERE");
      return widget.customHeader!.call(toggleVisibility);
    }
    List<Widget> headerItems = [
      Expanded(
        child: _headerTitle(),
      ),
    ];
    if ((widget.leadingIcon != Icons.expand_more) ||
        (widget.collapsible && widget.leadingIcon != null)) {
      headerItems.add(_headerIcon()!);
    }
    return InkWell(
      borderRadius: widget.headerBorderRadius,
      onTap: widget.onHeaderTap ??
          (widget.expandOnHeaderTap ? toggleVisibility : null),
      child: Padding(
        padding: widget.headerPadding,
        child: Row(
          children: headerItems,
        ),
      ),
    );
  }

  Widget _child() {
    if (widget.bottomDividerOnExpanded) {
      return Column(
        children: [widget.child, const Divider()],
      );
    }
    return widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _header(),
      SizeTransition(
        sizeFactor: animation,
        child: _child(),
      )
    ]);
  }
}
