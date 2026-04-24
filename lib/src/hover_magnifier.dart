import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hover_magnifier/utils/my_logger.dart';

class HoverMagnifier extends StatefulWidget {
  const HoverMagnifier({
    super.key,
    required this.child,
    required this.height,
    required this.magnifierOffset,
    required this.scale,
    required this.width,
  });

  final Widget child;
  final double scale;
  final double height;
  final double width;
  final Offset magnifierOffset;

  @override
  State<HoverMagnifier> createState() => _HoverMagnifierState();
}

class _HoverMagnifierState extends State<HoverMagnifier> {
  /// Screen Sizes

  double get _screenWidth => MediaQuery.sizeOf(context).width;
  double get _screenHeight => MediaQuery.sizeOf(context).height;

  /// Properties

  double get _scale => widget.scale;
  double get _width => widget.width;
  double get _height => widget.height;
  Offset get _offset => widget.magnifierOffset;

  /// Main Key that will be used to get the size & offset of the target widget

  final GlobalKey _key = GlobalKey();

  /// [HoverMagnifier] OverlayEntry builder

  OverlayEntry? _hoverOverlay;

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

        /// Takes the position of the mouse from the global and tells me where it is in the widget
        final Offset localePos = box.globalToLocal(Offset(dx, dy));

        // Catch the offsetX & offsetY for the translate

        final double offsetX = localePos.dx * _scale + _width / 2;
        final double offsetY = localePos.dy * _scale + _height / 2;

        // Calcualte the left & top values for the overlay

        final Offset globalPos = box.localToGlobal(Offset.zero);

        double left = globalPos.dx + widgetSize.width + _offset.dx;

        double top = globalPos.dy; // I do not want it to move on the y-axis

       

        return Positioned(
          top: top,
          left: left,
          width: _width,
          height: _height,
          child: Material(
            elevation: 8,
            child: DecoratedBox(
              decoration: const BoxDecoration(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: ClipRect(
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
        );
      },
    );
  }

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
      onEnter: (event) => _showOverlay(),
      onExit: (event) => _hideOverlay(),
      onHover: (event) {
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
