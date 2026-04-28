// ignore_for_file: avoid_unnecessary_containers

import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hover_magnifier/utils/assertion_msg.dart';
import 'package:hover_magnifier/utils/enums.dart';
import 'package:hover_magnifier/utils/overlay_decoration.dart';

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

  /// Access the properties of the [HoverMagnifier] widget

  double get _scale => widget.scale;
  double get _width => widget.width;
  double get _height => widget.height;
  Offset get _offset => widget.magnifierOffset;
  OverlayDecoration get _decoration => widget.decoration;

  /// Check [OverlayPosition.stayAround] to use it to perform the position implementation

  bool get _stayBehind => widget.overlayPosition == OverlayPosition.stayAround;

  /// This [GlobalKey] will be passed to the [MouseRegion] to extract
  /// [Size] & [Offset] to use it in the OverlayEntry that will show the
  /// magnifier effect

  final GlobalKey _key = GlobalKey();

  /// Build [BoxShape] layout wrapper for both the shape of [HoverMagnifier]
  /// and the glass effect as well

  Widget _buildShape({required Widget child}) {
    if (_decoration.shape == BoxShape.circle) {
      return ClipOval(child: child);
    }

    return ClipRRect(
      borderRadius: _decoration.borderRadius ?? BorderRadius.zero,
      child: child,
    );
  }

  //// Perform glass effect if [_decoration.applyGlassEffect] is `true`

  double get _glassSigma {
    if (!_decoration.applyGlassEffect) {
      return 0.0;
    }
    return _decoration.glassSigmaXY;
  }

  /// Build the body of the [HoverMagnifier]

  OverlayEntry? _hoverOverlay;

  OverlayEntry _buildHoverMgnifierEntry() {
    return OverlayEntry(
      builder: (context) {
        /// Get the RenderBox that will be used to extract the Offset & Size of the
        /// original widget, use it in the zoomed one

        final RenderBox? box =
            _key.currentContext?.findRenderObject() as RenderBox?;

        if (box == null) {
          log(RENDER, name: "HoverMagnifier");

          return const SizedBox.shrink();
        }

        /// Get the Size of the target widget (width & height)

        final Size widgetSize = box.size;

        /// Takes the position of the mouse from the global and tells me where it is in the widget
        ///
        /// Since `dy` & `dx` are updated from the cursor movement

        final Offset localePos = box.globalToLocal(Offset(dx, dy));

        /// Catch the offsetX & offsetY for the translate
        ///
        /// The value of the [localePos] is always (+), since it starts from [Offset.zero]
        /// then increase on `dx` on the x-axis & `dy` on the y-axis
        ///
        /// If the mouse cursor moves to the left the content of the viewport moves to the right, vise versa
        /// so I must muliply the value with negative to perfrom the moving of the mouse
        /// shifts the scaled widget so exactly the pixel under your cursor ends up centered in the overlay.
        ///
        /// About this value [ widgetSize.width / 2] the purpose of it is to set the view in the
        /// center of the mouse cursor instead of being at the edge of the original view

        final double offsetX = -localePos.dx * _scale + widgetSize.width / 2;
        final double offsetY = -localePos.dy * _scale + widgetSize.height / 2;

        /// I give it the Offset.zero which is the top-left of the widget then it returns
        /// where is this widget in the global(screen)

        final Offset globalPos = box.localToGlobal(Offset.zero);

        // Get the Position of the overlay in the screen

        double left = 0.0;
        double top = 0.0;

        if (_stayBehind) {
          left = globalPos.dx + widgetSize.width + _offset.dx;

          /// I do not want it to move on the y-axis unless there is not space, it will move

          top = globalPos.dy;
        } else {
          /// Simply, will follow the mouse with the given Offset

          left = dx + _offset.dx /* - _width / 2 */;
          top = dy + _offset.dy /* - _height / 2 */;
        }

        /// This condition to handle if the widget in the max right of the screen

        if (left + _width > _screenWidth) {
          /// I will get where the widget top-left position exist in the screen
          /// then substract the width of the widget and the horizontal space

          left = globalPos.dx - _width - _offset.dx;
        }

        /* if (top < 0 || _height > _screenHeight) {
          top = 0;
        }

        if (top + _height > _screenHeight) {
          top = dy - _height;
        } */

        /// Make sure that the `top` value will be always between the screen boundaries

        top = top.clamp(0.0, _screenHeight - _height);

        /// Make sure that the `left` value will be always between the screen boundaries

        left = left.clamp(0.0, _screenWidth - _width);
        
        return AnimatedPositioned(
          duration: widget.followMouseDuration,
          top: top,
          left: left,
          width: _width,
          height: _height,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: _buildShape(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _glassSigma,
                    sigmaY: _glassSigma,
                  ),
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

  /// Check if the platform is mobile so it will diable the [HoverMagnifier]

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

  /// Mouse position in the screen will be updated by these values

  double dx = 0.0;
  double dy = 0.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _key,
      onEnter: (event) {
        /// Show the magnifier overlay when mouse enters the widget,
        /// unless disabled or on mobile platform
        if (!widget.enabled || _isMobile) {
          return;
        }

        _showOverlay();
      },
      onExit: (event) {
        /// Hide the magnifier overlay when mouse leaves the widget,
        /// unless disabled or on mobile platform
        if (!widget.enabled || _isMobile) {
          return;
        }

        _hideOverlay();
      },
      onHover: (event) {
        /// Update magnifier position to follow cursor movement,
        /// unless disabled or on mobile platform
        if (!widget.enabled || _isMobile) {
          return;
        }

        setState(() {
          dx = event.position.dx;
          dy = event.position.dy;
        });

        /// Rebuild the overlay to reflect the new cursor position
        _hoverOverlay?.markNeedsBuild();
      },
      child: widget.child,
    );
  }
}
