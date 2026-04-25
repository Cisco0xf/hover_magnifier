import 'package:flutter/material.dart';
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
      theme: ThemeData(
        scaffoldBackgroundColor: ExColors.bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ExColors.primary,
        ),
      ),
    );
  }
}

class HoverMagnifierExample extends StatefulWidget {
  const HoverMagnifierExample({super.key});

  @override
  State<HoverMagnifierExample> createState() => _HoverMagnifierExampleState();
}


class _HoverMagnifierExampleState extends State<HoverMagnifierExample> {
  double get screenWidth => MediaQuery.sizeOf(context).width;
  double get screenHeight => MediaQuery.sizeOf(context).height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: ExColors.surface,
            ),
            child: const HoverMagnifier(
              height: 500,
              magnifierOffset: Offset(20.0, 0.0),
              scale: 2.0,
              width: 500,
              
            ),
          )
        ],
      ),
    );
  }
}
