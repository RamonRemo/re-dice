import 'package:flutter/material.dart';
import 'package:shake_detector/shake_detector.dart';
// import 'package:shake/shake.dart';
// import 'package:shake_gesture/shake_gesture.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int value = 0;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Home')), body: body());
  }

  Widget body() {
    return ShakeDetectWrap(
      enabled: true,
      onShake: _increment,
      child: Center(child: Text('Value: $value')),
    );

  }

  void _increment() {
    setState(() {
      value++;
    });
  }
}
