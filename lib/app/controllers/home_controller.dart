import 'package:flutter/material.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/controllers/arena_controller.dart';
import 'package:re_dice/app/controllers/dice_animation_controller.dart';
import 'package:re_dice/app/services/preferences_service.dart';
import 'package:re_dice/app/factories/renderer_factory.dart';
import 'package:re_dice/app/utils/constants.dart';

class HomeController extends ChangeNotifier {
  // Estado
  int _total = 0;
  List<Dice> _diceList = [];
  late ArenaController _arenaController;
  late DiceAnimationController _diceAnimController;
  late dynamic _diceRenderer;
  final Function(void Function()) setState;

  HomeController({required this.setState});

  // Getters
  int get total => _total;
  List<Dice> get diceList => _diceList;
  ArenaController get arenaController => _arenaController;
  dynamic get diceRenderer => _diceRenderer;

  // Inicialização
  void initialize(TickerProvider vsync) {
    _loadDiceList();
    _arenaController = ArenaController();
    _diceAnimController = DiceAnimationController(
      diceList: _diceList,
      vsync: vsync,
      arenaController: _arenaController,
      setState: setState,
    );
    _updateRenderer();
  }

  void updateDimensions(BuildContext context) {
    _arenaController.updateDimensions(context);
  }

  // Lógica de dados
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

  // Lógica de renderização
  void _updateRenderer() {
    _diceRenderer = RendererFactory.createDiceRenderer(
      arenaController: _arenaController,
      diceList: _diceList,
      animationController: _diceAnimController,
    );
  }

  // Actions
  void rollDice() {
    _total = _diceList.rollAll();
    _diceAnimController.startAnimation();
    final possible = _diceList.map((d) => d.sides).fold(0, (a, b) => a + b);
    PreferencesService.addRollHistory(_total, possible);

    notifyListeners();
  }

  void toggleTheme() {
    setState(() {
      Constants.updateColor(); // Atualiza a cor no Constants
    });
  }

  void addDice(int sides) {
    final newId =
        _diceList.isEmpty
            ? 1
            : _diceList.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1;

    _diceList.add(Dice(id: newId, sides: sides));
    _diceAnimController.resetDicePositions();
    _saveDiceList();
    notifyListeners();
  }

  void removeDice(Dice dice) {
    _diceList.remove(dice);
    _diceAnimController.resetDicePositions();
    _saveDiceList();
    notifyListeners();
  }

  void resetDiceList() {
    _diceList.clear();
    _diceList.add(Dice(id: 1, sides: 6));
    _diceAnimController.resetDicePositions();
    _saveDiceList();
    notifyListeners();
  }

  // Cleanup
  @override
  void dispose() {
    _diceAnimController.dispose();
    super.dispose();
  }
}
