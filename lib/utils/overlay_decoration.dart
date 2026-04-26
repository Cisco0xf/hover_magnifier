import 'package:flutter/material.dart';

class OverlayDecoration {
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? backgroundColor;
  final bool appyGlassEffect;

  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final BoxShape shape;

  final double glassSigmaXY;

  const OverlayDecoration({
    this.shape = BoxShape.rectangle,
    this.appyGlassEffect = true,
    this.glassSigmaXY = 2.0,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.border,
  });
}
