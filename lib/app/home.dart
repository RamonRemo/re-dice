import 'package:flutter/material.dart';
// import 'package:shake/shake.dart';
import 'package:shake_gesture/shake_gesture.dart';

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
    // ShakeDetector.autoStart(onPhoneShake: _increment);

    // return Center(child: Text('Value: $value'));

    return ShakeGesture(
      onShake: () {
        _increment();
        _shakeController.forward();
      },
      child: Center(
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _shakeAnimation.value * 0.1 * (value % 2 == 0 ? 1 : -1),
              child: Transform.scale(
                scale: 1.0 + (_shakeAnimation.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow:
                        _shakeAnimation.value > 0.5
                            ? [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10 * _shakeAnimation.value,
                                spreadRadius: 5 * _shakeAnimation.value,
                              ),
                            ]
                            : null,
                  ),
                  child: Text(
                    'Value: $value',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      value++;
    });
  }
}
