import 'package:flutter/material.dart';

/// Contenedor expandible horizontalmente con animación
class WidthAnimSizeContainer extends StatefulWidget {
  const WidthAnimSizeContainer({
    super.key,
    required this.child,
    this.maxWidth = 500,
    this.minWidth = 0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
    this.expanded,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final double maxWidth;
  final double minWidth;
  final ValueNotifier<bool>? expanded;

  @override
  State<WidthAnimSizeContainer> createState() => _WidthAnimSizeContainerState();
}

class _WidthAnimSizeContainerState extends State<WidthAnimSizeContainer> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: widget.duration,
      curve: widget.curve,
      child: SizedBox(
          width: widget.expanded!.value || false
              ? widget.maxWidth
              : widget.minWidth,
          child: widget.child),
    );
  }
}
