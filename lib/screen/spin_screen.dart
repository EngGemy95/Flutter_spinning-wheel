import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_files/wheel_painter.dart';
import '../state_provider/names_provider.dart';

class SpinScreen extends StatefulWidget {
  const SpinScreen({super.key});

  @override
  State<SpinScreen> createState() => _SpinScreenState();
}

class _SpinScreenState extends State<SpinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation = null;
  double _currentAngle = 0.0;
  String? selectedName;
  int selectedIndex = 0;
  bool showConfetti = false;
  ConfettiController _confettiController = ConfettiController();
  List<String> names = [];

  bool isSpinning = false;
  List<Color>? generatedColors;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void spinWheel(List<String> names, List<String> charNames) {
    if (isSpinning) return;

    setState(() {
      selectedName = "";
      isSpinning = true;
      showConfetti = false;
    });

    final random = Random();
    final spins = random.nextInt(10) + 5;
    print("spins = $spins");
    final stopAt = random.nextDouble();
    print("stopAt = ${stopAt}");
    final double targetAngle = 2 * pi * spins + (2 * pi * stopAt);
    print("targetAngle = $targetAngle");

    _animation = Tween<double>(begin: _currentAngle, end: targetAngle)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ))
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          final angle = _animation!.value % (2 * pi);
          print("Raw angle = $angle");
          final selectedAngle = (3 * pi / 2 - angle + 2 * pi) % (2 * pi);
          print("selectedAngle under arrow = $selectedAngle");
          final anglePerSection = 2 * pi / names.length;
          print("anglePerSection = $anglePerSection");
          final selectedIndex = (selectedAngle / anglePerSection).floor();
          print("selectedIndex = $selectedIndex");

          setState(() {
            this.selectedIndex = selectedIndex;
            selectedName = names[selectedIndex];
            showConfetti = true;
            isSpinning = false;
          });

          _confettiController.play();

          Future.delayed(const Duration(seconds: 5), () {
            setState(() {
              showConfetti = false;
              selectedName = "";
              this.names.removeAt(selectedIndex);
              charNames.removeAt(selectedIndex);
              generatedColors?.removeAt(selectedIndex);
              // if(this.names.length <2){
              //   Navigator.of(context).pop();
              // }
            });
          });

          _currentAngle = angle;
        }
      });

    _controller.duration = Duration(seconds: random.nextInt(15) + 10);
    _controller.forward(from: 0);
  }

  List<Color> generateUniqueColors(int count) {
    // final Set<int> usedColors = {};
    // final Random random = Random();
    // final List<Color> colors = [];
    //
    // while (colors.length < count) {
    //   // Generate random hex color like 0xFFxxxxxx
    //   final colorValue = 0xFF000000 | random.nextInt(0x00FFFFFF);
    //
    //   // If it's not used before, add it
    //   if (!usedColors.contains(colorValue)) {
    //     usedColors.add(colorValue);
    //     colors.add(Color(colorValue));
    //   }
    // }

    final List<Color> colors = [];
    final Random random = Random();
    final Set<int> usedColors = {};
    while (colors.length < count) {
      final colorValue = 0xFF000000 | random.nextInt(0x00FFFFFF);

      if (!usedColors.contains(colorValue)) {
        usedColors.add(colorValue);
        colors.add(Color(colorValue));
      }
    }

    return colors;
  }

  List<String> getInitialsName(List<String> names) {
    return names.map((name) {
      return name
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map((word) => word[0].toUpperCase())
          .join();
    }).toList();
  }

  String getCharName(String name) {
    return name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  @override
  Widget build(BuildContext context) {
    names = Provider.of<NameProvider>(context).names;
    List<String> charNames = [];
    final radius = 150.0;

    if (generatedColors == null || generatedColors!.length != names.length) {
      generatedColors = generateUniqueColors(names.length);
    }
    if (charNames.isEmpty) {
      charNames = getInitialsName(names);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Spin Wheel")),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      painter: WheelPainter(
                        names: names,
                        charNames: charNames,
                        colors: generatedColors!,
                        currentAngle: _animation?.value ?? _currentAngle,
                      ),
                      size: Size(radius * 1.75, radius * 2),
                    ),
                    const Positioned(
                      top: -5,
                      child: Icon(Icons.arrow_drop_down,
                          size: 40, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      isSpinning ? null : () => spinWheel(names, charNames),
                  child: const Text("SPIN"),
                ),
                const SizedBox(height: 20),
                if (selectedName != null)
                  Text(
                    "Winner : $selectedName",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          if (showConfetti)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 20,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 2,
                  emissionFrequency: 0.1,
                  numberOfParticles: 20,
                  gravity: 0.1,
                  shouldLoop: false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
