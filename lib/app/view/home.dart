import 'package:flutter/material.dart';
import 'package:re_dice/app/controllers/home_controller.dart';
import 'package:re_dice/app/models/dice.dart';
import 'package:re_dice/app/view/dices_modal.dart';
import 'package:re_dice/app/view/history_modal.dart';
import 'package:re_dice/app/factories/arena_factory.dart';
import 'package:re_dice/app/widget/buttons/bottom_buttons.dart';
import 'package:re_dice/app/widget/buttons/theme_toggle.dart';
import 'package:re_dice/app/widget/total_value.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:re_dice/app/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(setState: setState);
    _controller.initialize(this);
    _controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.updateDimensions(context);

    return Scaffold(body: _buildBody(), backgroundColor: Constants.background);
  }

  Widget _buildBody() {
    return ShakeDetectWrap(
      enabled: true,
      onShake: _controller.rollDice,
      child: Stack(
        children: [
          ArenaFactory.createArena(
            left: _controller.arenaController.arenaLeft,
            top: _controller.arenaController.arenaTop,
            width: _controller.arenaController.arenaWidth,
            height: _controller.arenaController.arenaHeight,
          ),
          ..._controller.diceRenderer.renderDice(),
          Positioned(
            top: 40,
            right: 20,
            child: ThemeToggle(onTap: _controller.toggleTheme),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomButtons(
              rollFunction: _controller.rollDice,
              dicesFunction: _showDicesModal,
              historyFunction: _showHistoryModal,
            ),
          ),
          TotalWidget(
            total: _controller.total.toString(),
            diceList:
                _controller.diceList.groupByType().entries.map((entry) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '${entry.value}d${entry.key}',
                      style: TextStyle(fontSize: 20, color: Constants.primary),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  void _showDicesModal() async {
    await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => DiceSelectionModal(
                  diceList: _controller.diceList,
                  onAddDice: (sides) {
                    _controller.addDice(sides);
                    setModalState(() {}); // Força reconstrução do modal
                  },
                  onRemoveDice: (dice) {
                    _controller.removeDice(dice);
                    setModalState(() {}); // Força reconstrução do modal
                  },
                  onReset: () {
                    _controller.resetDiceList();
                    setModalState(() {}); // Força reconstrução do modal
                    Navigator.pop(context);
                  },
                ),
          ),
    );
  }

  void _showHistoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const HistoryModal(),
    );
  }
}
