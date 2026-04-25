import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:hover_magnifier/hover_magnifier.dart';
import 'package:hover_magnifier/utils/magnifier_decoration.dart';

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
}

class HoverMagnifierExample extends StatefulWidget {
  const HoverMagnifierExample({super.key});

  @override
  State<HoverMagnifierExample> createState() => _HoverMagnifierExampleState();
}

class _HoverMagnifierExampleState extends State<HoverMagnifierExample> {
  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => MediaQuery.sizeOf(context).height;

  BorderRadius borderRadius(double radius) => BorderRadius.circular(radius);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius(10.0),
                color: ExColors.surface,
              ),
              width: screenWidth * 0.4,
              height: screenHeight * .9,
              child: HoverMagnifier(
                scale: 2.0,
                width: 500,
                height: 600,
                magnifierOffset: const Offset(20.0, 0.0),
                decoration: OverlayDecoration(
                  backgroundColor: ExColors.surface,
                  border: Border.all(color: ExColors.primary),
                ),
                child: ClipRRect(
                  borderRadius: borderRadius(10.0),
                  child: AvifImage.asset(
                    Assets.image1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * .5,
              child: HoverMagnifier(
                height: 400,
                scale: 1.5,
                width: 400,
                magnifierOffset: Offset(20.0, 0.0),
                decoration: OverlayDecoration(
                  backgroundColor: ExColors.surface,
                  borderRadius: borderRadius(10.0),
                ),
                child: const Text(
                  textEx,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
