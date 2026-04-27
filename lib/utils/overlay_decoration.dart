import 'package:flutter/material.dart';

class OverlayDecoration {
  /// Decoration options for the magnifier overlay.
  ///
  /// This class controls the visual appearance of the magnifier window,
  /// including shape, background, border, shadow, gradient, and glass blur.
  final BorderRadius? borderRadius;

  /// Optional shadow applied behind the overlay.
  final List<BoxShadow>? boxShadow;

  /// Background color for the overlay.
  final Color? backgroundColor;

  /// Whether to apply a glass blur effect behind the overlay.
  final bool applyGlassEffect;

  /// Blur sigma for the glass effect when enabled.
  final double glassSigmaXY;

  /// Optional gradient used to paint the overlay background.
  final Gradient? gradient;

  /// Optional border drawn around the overlay.
  final Border? border;

  /// Shape of the overlay: rectangle or circle.
  final BoxShape shape;

  const OverlayDecoration({
    this.shape = BoxShape.rectangle,
    this.applyGlassEffect = true,
    this.glassSigmaXY = 2.0,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.gradient,
    this.border,
  });
}
