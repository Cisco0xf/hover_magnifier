import 'package:flutter/material.dart';

class OverlayDecoration {
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? backgroundColor;
  final bool appyGlassEffect;

  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BoxShape shape;

  const OverlayDecoration({
    this.borderRadius ,
    this.shape = BoxShape.rectangle,
    this.appyGlassEffect = false,
    this.backgroundColor,
    this.boxShadow,
    this.gradient,
    this.border,
  });
}
