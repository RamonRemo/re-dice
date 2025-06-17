import 'package:flutter/material.dart';
import 'package:re_dice/app/model/dice.dart';
import 'package:re_dice/app/view/dices_modal.dart';
import 'package:re_dice/app/widget/dice_renderer.dart';
import 'package:re_dice/objectbox.g.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/utils/constants.dart';

class Home extends StatefulWidget {
  final Store store;

  const Home({super.key, required this.store});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int total = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Modelo de dados
  final List<Dice> _diceList = <Dice>[Dice(id: 1, sides: 6)];
  

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
      key: _scaffoldKey,
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

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: _increment,
                    child: Text(
                      'Roll',
                      style: TextStyle(
                        fontSize: 30,
                        color: Constants.matrixGreen,
                      ),
                    ),
                  ),
                  Text('|'),
                  TextButton(
                    onPressed: () {
                      dicesBottomSheet();
                    },
                    child: Text(
                      'Dices',
                      style: TextStyle(
                        fontSize: 30,
                        color: Constants.matrixGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text(
                    '$total',
                    style: TextStyle(
                      fontSize: 40,
                      color: Constants.matrixGreen,
                    ),
                  ),
                  //a list with each dice and his sides
                  Wrap(
                    spacing: 10,
                    children:
                        _diceList.groupByType().entries.map((entry) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '${entry.value}d${entry.key}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Constants.matrixGreen,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ],
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

  dicesBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DiceSelectionModal(
              diceList: _diceList,
              onAddDice: (sides) {
                setState(() {
                  // Add a new dice with these sides
                  final newId =
                      _diceList.isEmpty
                          ? 1
                          : _diceList
                                  .map((d) => d.id)
                                  .reduce((a, b) => a > b ? a : b) +
                              1;
                  _diceList.add(Dice(id: newId, sides: sides));
                  _diceAnimController.resetDicePositions();
                });
                setModalState(() {});
              },
              onRemoveDice: (dice) {
                setState(() {
                  _diceList.remove(dice);
                  _diceAnimController.resetDicePositions();
                });
                setModalState(() {});
              },
            );
          },
        );
      },
    );
  }
}
