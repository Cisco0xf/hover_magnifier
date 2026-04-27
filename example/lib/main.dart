import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:hover_magnifier/hover_magnifier.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HoverMagnifierExample(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: ExColors.bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ExColors.primary,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}

class ExColors {
  ExColors._();

  static const Color primary = Color(0xFF00e3fd);
  static const Color bgColor = Color(0xFF0e0e0e);
  static const Color surface = Color(0xFF262626);
}

class Assets {
  static const String _base = "assets/images/";

  static const String image1 = "${_base}5.avif";
  static const String image2 = "${_base}6.avif";
  static const String image3 = "${_base}7.avif";
  static const String image4 = "${_base}8.avif";
  static const String image5 = "${_base}9.avif";
  static const String image6 = "${_base}1.avif";
}

const String textEx =
    "The James Webb Space Telescope (JWST) is the largest and most powerful "
    "space telescope ever built. Launched on December 25, 2021, it orbits the "
    "Sun at a distance of 1.5 million kilometers from Earth. Webb is designed "
    "to observe the universe in infrared light, allowing it to peer through "
    "dust clouds and see the earliest galaxies formed after the Big Bang, "
    "over 13.5 billion years ago. Its primary mirror spans 6.5 meters and "
    "is composed of 18 hexagonal gold-plated beryllium segments. Scientists "
    "use Webb to study the atmospheres of exoplanets, the formation of stars, "
    "and the structure of distant galaxies. It represents one of humanity's "
    "greatest engineering achievements and a new era of astronomical discovery.\n\n"
    "Penguins are flightless seabirds that live almost exclusively below the equator."
    " Some island-dwellers can be found in warmer climates, but most—including emperor,"
    " adélie, chinstrap, and gentoo penguins—reside in and around icy Antarctica. "
    "A thick layer of blubber and tightly-packed, oily feathers are ideal for colder temperatures.";

class HoverMagnifierExample extends StatefulWidget {
  const HoverMagnifierExample({super.key});

  @override
  State<HoverMagnifierExample> createState() => _HoverMagnifierExampleState();
}

class _HoverMagnifierExampleState extends State<HoverMagnifierExample>
    with AutomaticKeepAliveClientMixin {
  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => MediaQuery.sizeOf(context).height;
  bool get isMobile => screenWidth < 768;
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;

  BorderRadius? borderRadius(double radius, bool chacker) =>
      _shape(chacker) == BoxShape.circle ? null : BorderRadius.circular(radius);

  double dx = 0.0;
  double dy = 0.0;

  List<String> images = [
    Assets.image1,
    Assets.image3,
    Assets.image4,
    Assets.image5,
    Assets.image6,
  ];

  bool followMouse1 = false;
  bool isCircle1 = false;
  double scale1 = 2.0;

  bool followMouse2 = true;
  bool isCircle2 = true;
  double scale2 = 2.0;

  bool followMouse3 = false;
  bool isCircle3 = false;
  double scale3 = 2.0;

  bool followMouse4 = false;
  bool isCircle4 = false;
  double scale4 = 2.0;

  BoxShape _shape(bool chacker) =>
      chacker ? BoxShape.circle : BoxShape.rectangle;
  OverlayPosition _position(bool checker) =>
      checker ? OverlayPosition.followMouse : OverlayPosition.stayAround;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FullMagnifier(
                  followMouse: followMouse1,
                  isCircle: isCircle1,
                  onMouseChanged: (p0) => setState(() => followMouse1 = p0),
                  onShapeChanged: (p0) => setState(() => isCircle1 = p0),
                  onScaleChanged: (value) => setState(() => scale1 = value),
                  scale: scale1,
                  child: SizedBox(
                    width: screenWidth * 0.36,
                    height: screenHeight * .75,
                    child: PageView.builder(
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: borderRadius(10.0, false),
                            color: ExColors.surface,
                          ),
                          width: screenWidth * 0.35,
                          height: screenHeight * .75,
                          child: HoverMagnifier(
                            width: isCircle1 ? 250 : 400,
                            height: isCircle1 ? 250.0 : 500,
                            magnifierOffset: const Offset(20.0, 0.0),
                            scale: scale1,
                            overlayPosition: _position(followMouse1),
                            decoration: OverlayDecoration(
                              shape: _shape(isCircle1),
                              backgroundColor:
                                  ExColors.surface.withOpacity(0.2),
                              border: Border.all(
                                  color: ExColors.primary, width: 3.0),
                              borderRadius: borderRadius(10.0, isCircle1),
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius(10.0, false) ??
                                  BorderRadius.zero,
                              child: AvifImage.asset(
                                images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                FullMagnifier(
                  followMouse: followMouse2,
                  isCircle: isCircle2,
                  onMouseChanged: (p0) => setState(() => followMouse2 = p0),
                  onShapeChanged: (p0) => setState(() => isCircle2 = p0),
                  onScaleChanged: (value) => setState(() => scale2 = value),
                  scale: scale2,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: screenWidth * .5,
                    height: screenHeight * .75,
                    child: HoverMagnifier(
                      height: 200.0,
                      width: 200.0,
                      scale: scale2,
                      overlayPosition: _position(followMouse2),
                      decoration: OverlayDecoration(
                        backgroundColor: ExColors.surface.withOpacity(0.2),
                        shape: _shape(isCircle2),
                        borderRadius: borderRadius(10, isCircle2),
                        border: Border.all(color: ExColors.primary),
                      ),
                      child: const Text(
                        textEx,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FullMagnifier(
                  followMouse: followMouse3,
                  isCircle: isCircle3,
                  onMouseChanged: (p0) => setState(() => followMouse3 = p0),
                  onShapeChanged: (p0) => setState(() => isCircle3 = p0),
                  onScaleChanged: (value) => setState(() => scale3 = value),
                  scale: scale3,
                  child: SizedBox(
                    height: screenHeight * .7,
                    child: HoverMagnifier(
                      height: 300,
                      width: 300,
                      scale: scale3,
                      overlayPosition: _position(followMouse3),
                      decoration: OverlayDecoration(
                        border: Border.all(color: Colors.amber),
                        shape: _shape(isCircle3),
                        borderRadius: borderRadius(10, isCircle3),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.scale,
                          size: 120.0,
                        ),
                      ),
                    ),
                  ),
                ),
                FullMagnifier(
                  followMouse: followMouse4,
                  isCircle: isCircle4,
                  onMouseChanged: (p0) => setState(() => followMouse4 = p0),
                  onShapeChanged: (p0) => setState(() => isCircle4 = p0),
                  onScaleChanged: (value) => setState(() => scale4 = value),
                  scale: scale4,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius(10.0, false),
                      color: ExColors.surface,
                    ),
                    width: screenWidth * 0.35,
                    height: screenHeight * .7,
                    child: HoverMagnifier(
                      height: 400,
                      width: isCircle4 ? 400 : 500,
                      scale: scale4,
                      overlayPosition: _position(followMouse4),
                      magnifierOffset: const Offset(30.0, 0.0),
                      decoration: OverlayDecoration(
                        backgroundColor: ExColors.surface.withOpacity(0.2),
                        border: Border.all(color: ExColors.primary),
                        borderRadius: borderRadius(10.0, isCircle4),
                        shape: _shape(isCircle4),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            borderRadius(10.0, false) ?? BorderRadius.zero,
                        child: AvifImage.asset(
                          Assets.image2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /*  SizedBox.square(
              dimension: screenHeight * 0.8,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: MouseRegion(
                    onHover: (details) {
                      setState(() {
                        dx = details.localPosition.dx;
                        dy = details.localPosition.dy;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius(10.0, isCircle1),
                        color: ExColors.surface,
                      ),
                      width: screenWidth * 0.4,
                      height: screenHeight * .9,
                      child: ClipRRect(
                        borderRadius: borderRadius(10.0, isCircle1),
                        child: AvifImage.asset(
                          Assets.image2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
                  Positioned(
                    left: dx,
                    top: dy,
                    child: RawMagnifier(
                      size: Size(500, 500),
                      magnificationScale: 2.0,
                    ),
                  ),
                ],
              ),
            ) */
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FullMagnifier extends StatelessWidget {
  const FullMagnifier({
    super.key,
    required this.onMouseChanged,
    required this.onShapeChanged,
    required this.isCircle,
    required this.followMouse,
    required this.child,
    required this.onScaleChanged,
    required this.scale,
  });

  final void Function(bool) onMouseChanged;
  final void Function(bool) onShapeChanged;
  final bool isCircle;
  final bool followMouse;

  final Widget child;

  final double scale;
  final void Function(double value) onScaleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Switch(value: isCircle, onChanged: onShapeChanged),
                    const SizedBox(width: 7.0),
                    const Text("Circle Shape"),
                  ],
                ),
                const SizedBox(width: 30.0),
                Row(
                  children: [
                    Switch(value: followMouse, onChanged: onMouseChanged),
                    const SizedBox(width: 7.0),
                    const Text("Follow Mouse"),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Scale: ${scale.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: scale,
              onChanged: onScaleChanged,
              min: 1.0,
              max: 4.0,
            ),
          ],
        )
      ],
    );
  }
}
