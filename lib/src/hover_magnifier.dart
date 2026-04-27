// ignore_for_file: avoid_unnecessary_containers

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hover_magnifier/utils/assertion_msg.dart';
import 'package:hover_magnifier/utils/enums.dart';
import 'package:hover_magnifier/utils/overlay_decoration.dart';
import 'package:hover_magnifier/utils/my_logger.dart';

class HoverMagnifier extends StatefulWidget {
  /// I have built this package to simulate the Amazon & Noon product zooming effect.
  ///
  /// It is for `web` & `desktop` only. NOT available for mobile.

  HoverMagnifier({
    super.key,
    required this.child,
    required this.height,
    this.magnifierOffset = Offset.zero,
    required this.scale,
    required this.width,
    this.enabled = true,
    this.decoration = const OverlayDecoration(),
    this.overlayPosition = OverlayPosition.stayAround,
    this.followMouseDuration = Duration.zero,
  })  : assert(
          !(decoration.shape == BoxShape.circle &&
              decoration.borderRadius != null),
          SHAPE_ASSERT,
        ),
        assert(width >= 0.0 && height >= 0.0, SIZE_ASSERT),
        assert(scale >= 0.0, SCALE_ASSERT);

  /// The widget that [HoverMagnifier] will magnify when hovering over it.
  ///
  /// This widget will be displayed at the original scale in the target area,
  /// and at the magnified scale in the magnifier overlay.
  ///
  /// Cannot be null. It is recommended to wrap this child with a [SizedBox]
  /// or [Size] widget specifying explicit `width` and `height` for optimal results.

  final Widget child;

  /// The scale of the zoomed child

  final double scale;

  /// Height of the [HoverMagnifier]
  ///
  /// If the [BoxShape] argument is [BoxShape.circle], `width` & `height` MUST be the same

  final double height;

  /// Width of the [HoverMagnifier]
  ///
  /// If the [BoxShape] argument is [BoxShape.circle], `width` & `height` MUST be the same

  final double width;

  /// The offset of the magnifier window from the mouse cursor position.
  ///
  /// Controls how many pixels away from the cursor the magnifier overlay
  /// appears. Positive values move it right and down, negative values move it
  /// left and up.
  ///
  /// Defaults to [Offset.zero], positioning the magnifier at the cursor.
  final Offset magnifierOffset;

  /// Decoration configuration for the magnifier overlay appearance.
  ///
  /// Defines the visual styling of the magnifier window including background,
  /// border, shape, and effects. Note that [borderRadius] must be null when
  /// [shape] is [BoxShape.circle] to maintain proper circular clipping.
  ///
  /// Individual properties (color, image, border, shadow, gradient) are optional
  /// and only applied if provided.
  final OverlayDecoration decoration;

  /// Controls where the magnifier overlay appears relative to the target widget.
  ///
  /// * [OverlayPosition.stayAround] - Positions the magnifier beside the target
  ///   widget, maintaining a fixed relationship with it.
  /// * [OverlayPosition.followMouse] - Positions the magnifier to follow the
  ///   mouse cursor as it moves over the target widget.

  final OverlayPosition overlayPosition;

  /// Enables or disables the magnifier effect.
  ///
  /// When `false`, hovering over the child widget will not display the magnifier.
  /// On mobile platforms (`iOS` and Android), this is `false` by default since
  /// hover effects are not applicable.

  final bool enabled;

  /// Animation duration for magnifier position changes when following the mouse.
  ///
  /// When [overlayPosition] is [OverlayPosition.followMouse], this defines how
  /// smoothly the magnifier animates to new positions. Set to [Duration.zero]
  /// for instant positioning without animation.

  final Duration followMouseDuration;

  @override
  State<HoverMagnifier> createState() => _HoverMagnifierState();
}

class _HoverMagnifierState extends State<HoverMagnifier> {
  /// Get `screenWidth` & `screenHeight` from [MediaQuery]

  double get _screenWidth => MediaQuery.sizeOf(context).width;
  double get _screenHeight => MediaQuery.sizeOf(context).height;

  /// Access the properties of the [HoverMagnifier]

  

  OverlayEntry? _hoverOverlay;

  Widget _buildShape({required Widget child}) {
    if (_decoration.shape == BoxShape.circle) {
      return ClipOval(child: child);
    }

    return ClipRRect(
      borderRadius: _decoration.borderRadius ?? BorderRadius.zero,
      child: child,
    );
  }

  // Glass Properties

  double get _glassSigma {
    if (!_decoration.appyGlassEffect) {
      return 0.0;
    }
    return _decoration.glassSigmaXY;
  }

  OverlayEntry _buildHoverMgnifierEntry() {
    return OverlayEntry(
      builder: (context) {
        // Get the [RenderBox] from the key of the MaouseRegion

        final RenderBox? box =
            _key.currentContext?.findRenderObject() as RenderBox?;

        if (box == null) {
          Log.error("RenderBox Gives null value");

          return const SizedBox.shrink();
        }

        /// Get the Propeties from the RenderBox
        ///
        /// Get the Size of the target widget (width & height)

        final Size widgetSize = box.size;

        /// Takes the position of the mouse from the global and tells me where it is in the widget
        final Offset localePos = box.globalToLocal(Offset(dx, dy));

        // Catch the offsetX & offsetY for the translate

        final double offsetX = -localePos.dx * _scale + widgetSize.width / 2;
        final double offsetY = -localePos.dy * _scale + widgetSize.height / 2;

        // Calcualte the left & top values for the overlay

        final Offset globalPos = box.localToGlobal(Offset.zero);

        // Get the Position of the overlay in the screen

        double horizontal = 0.0;
        double top = 0.0;

        if (_stayBehind) {
          horizontal = globalPos.dx + widgetSize.width + _offset.dx;

          // I do not want it to move on the y-axis
          top = globalPos.dy;
        } else {
          horizontal = dx + _offset.dx /* - _width / 2 */;
          top = dy + _offset.dy /* - _height / 2 */;
        }

        if (horizontal + _width > _screenWidth) {
          /// horizontal = dx - _width - _offset.dx;
          /// horizontal = globalPos.dx - (_width / 2) - (_offset.dx / 2);
          horizontal = globalPos.dx - _width - _offset.dx;

          horizontal = horizontal.clamp(0.0, _screenWidth - _width);
        }

        if (top < 0 || _height > _screenHeight) {
          top = 0;
        }

        if (top + _height > _screenHeight) {
          top = dy - _height;
        }

        return AnimatedPositioned(
          duration: widget.followMouseDuration,
          top: top,
          left: horizontal,
          /*  left: _left ? horizontal : null,
          right: _left ? null : horizontal, */
          width: _width,
          height: _height,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: _buildShape(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: _glassSigma, sigmaY: _glassSigma),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: _decoration.borderRadius,
                      border: _decoration.border,
                      color: _decoration.backgroundColor,
                      boxShadow: _decoration.boxShadow,
                      gradient: _decoration.gradient,
                      shape: _decoration.shape,
                    ),
                    child: _buildShape(
                      child: OverflowBox(
                        minHeight: 0.0,
                        minWidth: 0.0,
                        maxHeight: double.infinity,
                        maxWidth: double.infinity,
                        child: Transform.translate(
                          offset: Offset(offsetX, offsetY),
                          child: Transform.scale(
                            scale: _scale,
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: widgetSize.width,
                              height: widgetSize.height,
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ///
  bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// [HoverMagnifier] Controllers

  void _showOverlay() {
    _hoverOverlay = _buildHoverMgnifierEntry();
    Overlay.of(context).insert(_hoverOverlay!);
  }

  void _hideOverlay() {
    _hoverOverlay?.remove();
    _hoverOverlay = null;
  }

  double dx = 0.0;
  double dy = 0.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _key,
      onEnter: (event) {
        if (!widget.enabled || _isMobile) {
          return;
        }

        _showOverlay();
      },
      onExit: (event) {
        if (!widget.enabled || _isMobile) {
          return;
        }

        _hideOverlay();
      },
      onHover: (event) {
        if (!widget.enabled || _isMobile) {
          return;
        }

        setState(() {
          dx = event.position.dx;
          dy = event.position.dy;
        });

        _hoverOverlay?.markNeedsBuild();
      },
      child: widget.child,
    );
  }
}
