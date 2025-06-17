import 'package:flutter/material.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/models/visual_theme.dart';
import 'package:re_dice/app/view/dices_modal.dart';
import 'package:re_dice/app/factories/renderer_factory.dart';
import 'package:re_dice/app/factories/arena_factory.dart';
import 'package:re_dice/app/services/theme_service.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/utils/constants.dart';
import 'package:re_dice/app/services/preferences_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int total = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Modelo de dados
  late List<Dice> _diceList;

  // Controllers
  late ArenaController _arenaController;
  late DiceAnimationController _diceAnimController;
  late dynamic _diceRenderer;

  @override
  void initState() {
    super.initState();
    _loadDiceList();
    _arenaController = ArenaController();
    _diceAnimController = DiceAnimationController(
      diceList: _diceList,
      vsync: this,
      arenaController: _arenaController,
      setState: setState,
    );
    _updateRenderer();
  }

  void _loadDiceList() {
    final savedDice = PreferencesService.getDiceList();
    if (savedDice.isNotEmpty) {
      _diceList =
          savedDice
              .map(
                (diceMap) => Dice(id: diceMap['id']!, sides: diceMap['sides']!),
              )
              .toList();
    } else {
      _diceList = [Dice(id: 1, sides: 6)];
    }
  }

  void _saveDiceList() {
    final diceMapList =
        _diceList.map((dice) => {'id': dice.id, 'sides': dice.sides}).toList();
    PreferencesService.saveDiceList(diceMapList);
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

  void _updateRenderer() {
    _diceRenderer = RendererFactory.createDiceRenderer(
      arenaController: _arenaController,
      diceList: _diceList,
      animationController: _diceAnimController,
    );
  }

  void _toggleTheme() {
    setState(() {
      ThemeService.toggleTheme();
      _updateRenderer();
    });
  }

  Widget body() {
    return ShakeDetectWrap(
      enabled: true,
      onShake: _increment,
      child: Stack(
        children: [
          ArenaFactory.createArena(
            arenaLeft: _arenaController.arenaLeft,
            arenaTop: _arenaController.arenaTop,
            arenaWidth: _arenaController.arenaWidth,
            arenaHeight: _arenaController.arenaHeight,
          ),

          // Render dice within arena
          ..._diceRenderer.renderDice(),

          // Theme toggle button
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _toggleTheme,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Constants.matrixGreen, width: 2),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    ThemeService.currentTheme == VisualTheme.modern
                        ? 'v1'
                        : 'v0',
                    style: TextStyle(
                      color: Constants.matrixGreen,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

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
                  Text('|'),
                  TextButton(
                    onPressed: _showHistory,
                    child: Text(
                      'History',
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
      final possible = _diceList.map((d) => d.sides).fold(0, (a, b) => a + b);
      PreferencesService.addRollHistory(total, possible);
    });
  }

  void _showHistory() {
    final history = PreferencesService.getRollHistory();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800, maxHeight: 600),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Constants.matrixGreen),
            ),
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Constants.matrixGreen),
                  child: DataTable(
                    dividerThickness: 1,
                    columns: [
                      DataColumn(
                        label: Text(
                          'Time',
                          style: TextStyle(color: Constants.matrixGreen),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Value',
                          style: TextStyle(color: Constants.matrixGreen),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Total',
                          style: TextStyle(color: Constants.matrixGreen),
                        ),
                      ),
                    ],
                    rows:
                        history.reversed.map((record) {
                          final parts = record.split(':  ');
                          final time = parts[0];
                          final values =
                              parts.length > 1
                                  ? parts[1].split('  /  ')
                                  : ['', ''];
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: Constants.matrixGreen,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  values[0],
                                  style: TextStyle(
                                    color: Constants.matrixGreen,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  values[1],
                                  style: TextStyle(
                                    color: Constants.matrixGreen,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _resetDiceList() {
    setState(() {
      _diceList.clear();
      _diceList.add(Dice(id: 1, sides: 6));
      _diceAnimController.resetDicePositions();
      _saveDiceList();
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
                  final newId =
                      _diceList.isEmpty
                          ? 1
                          : _diceList
                                  .map((d) => d.id)
                                  .reduce((a, b) => a > b ? a : b) +
                              1;
                  _diceList.add(Dice(id: newId, sides: sides));
                  _diceAnimController.resetDicePositions();
                  _saveDiceList();
                });
                setModalState(() {});
              },
              onRemoveDice: (dice) {
                setState(() {
                  _diceList.remove(dice);
                  _diceAnimController.resetDicePositions();
                  _saveDiceList();
                });
                setModalState(() {});
              },
              onReset: () {
                _resetDiceList();
                setModalState(() {});
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
