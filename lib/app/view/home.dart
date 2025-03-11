import 'package:flutter/material.dart';
import 'package:re_dice/app/model/dice.dart';
import 'package:re_dice/app/widget/dice_renderer.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int total = 0;

  // Modelo de dados
  final List<Dice> _diceList = <Dice>[
    Dice(id: 1, sides: 6),
    Dice(id: 2, sides: 6),
    Dice(id: 3, sides: 6),
    Dice(id: 4, sides: 6),
  ];

  // Controllers
  late ArenaController _arenaController;
  late DiceAnimationController _diceAnimController;
  late DiceRenderer _diceRenderer;

  @override
  void initState() {
    super.initState();

    _arenaController = ArenaController();

    _diceAnimController = DiceAnimationController(
      diceList: _diceList,
      vsync: this,
      arenaController: _arenaController,
      setState: setState,
    );

    _diceRenderer = DiceRenderer(
      arenaController: _arenaController,
      diceList: _diceList,
      animationController: _diceAnimController,
    );
  }

  @override
  void dispose() {
    _diceAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Atualiza dimensões da arena
    _arenaController.updateDimensions(context);

    return Scaffold(
      body: body(),
      backgroundColor: Colors.black,
    );
  }

  Widget body() {
    return ShakeDetectWrap(
      enabled: true,
      onShake: _increment,
      child: Stack(
        children: [
          // Arena background
          _arenaController.buildArena(),

          // Render dice within arena
          ..._diceRenderer.renderDice(),

          // Roll button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: TextButton(
                onPressed: _increment,
                child: Text(
                  'Roll Dice',
                  style: TextStyle(fontSize: 30, color: Constants.matrixGreen),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                '$total',
                style: TextStyle(fontSize: 40, color: Constants.matrixGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      // Roll the dice
      total = _diceList.rollAll();
      print('Dice rolled: $total');

      // Apply random velocities and animate
      _diceAnimController.startAnimation();
    });
  }
}
