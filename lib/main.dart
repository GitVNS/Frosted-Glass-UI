import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frost/code.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<Color> gradientColors = [];
  bool noise = true;
  bool glassBorder = true;
  double glassThickness = 0.2;

  @override
  void initState() {
    super.initState();
    generateGradient();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  toggleAnimation() {
    if (_animation.status != AnimationStatus.completed) {
      _controller.forward();
    } else {
      _controller.animateBack(0, duration: const Duration(milliseconds: 100));
    }
  }

  generateGradient() {
    Color color1 = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
    Color color2 = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
    Color color3 = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
    Color color4 = Color.fromRGBO(
        Random().nextInt(255), Random().nextInt(255), Random().nextInt(255), 1);
    gradientColors = [color1, color2, color3, color4];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.1,
          vertical: size.height * 0.1,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: glassBorder
                      ? Border.all(color: Colors.white30, width: 2)
                      : null,
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade300.withOpacity(glassThickness),
                      Colors.white.withOpacity(glassThickness),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  image: noise
                      ? const DecorationImage(
                          image: AssetImage("image/noise.png"),
                          fit: BoxFit.cover)
                      : null,
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  children: [
                    buildGlowingTitle(),
                    const SizedBox(height: 12),
                    buildInkButton(
                        context: context,
                        title: "Change Background Gradient",
                        onTap: () {
                          generateGradient();
                        }),
                    buildDivider(),
                    buildInkButton(
                        context: context,
                        title: "Show Code",
                        onTap: () {
                          toggleAnimation();
                        }),
                    buildCodeSnippet(),
                    buildDivider(),
                    buildSwitchTile(
                      switchValue: noise,
                      title: "Noise",
                      onChanged: (value) {
                        setState(() {
                          noise = value;
                        });
                      },
                    ),
                    buildDivider(),
                    buildSwitchTile(
                      switchValue: glassBorder,
                      title: "Border",
                      onChanged: (value) {
                        setState(() {
                          glassBorder = value;
                        });
                      },
                    ),
                    buildDivider(),
                    const Text(
                      "Glass Thickness",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    Slider(
                      value: glassThickness,
                      max: 0.6,
                      min: 0.1,
                      activeColor: Colors.black,
                      thumbColor: Colors.white,
                      inactiveColor: Colors.black26,
                      onChanged: (value) {
                        setState(() {
                          glassThickness = value;
                        });
                      },
                    ),
                    buildDivider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGlowingTitle() {
    return const Text(
      'Frost',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Colors.white70,
        shadows: [
          Shadow(
            color: Colors.white,
            blurRadius: 6,
          ),
        ],
      ),
    );
  }

  Widget buildCodeSnippet() {
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Code(
              colorOpacity: glassThickness,
              border: glassBorder
                  ? "Border.all(color: Colors.white30, width: 2)"
                  : "null",
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Column(
      children: [
        SizedBox(height: 6),
        Divider(color: Colors.white24, thickness: 2),
        SizedBox(height: 6),
      ],
    );
  }

  Widget buildInkButton(
      {required BuildContext context,
      required String title,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashFactory: InkSparkle.splashFactory,
        onTap: onTap,
        child: Ink(
          height: 84,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black12,
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitchTile(
      {required bool switchValue,
      required String title,
      required Function(bool) onChanged}) {
    return SwitchListTile(
      value: switchValue,
      onChanged: onChanged,
      thumbColor: const MaterialStatePropertyAll(Colors.white),
      activeTrackColor: Colors.black,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white70,
        ),
      ),
    );
  }
}
