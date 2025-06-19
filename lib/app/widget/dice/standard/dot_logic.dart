import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';

class D6Dots extends StatelessWidget {
  final int value;
  const D6Dots({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(4),
      children: List.generate(9, (index) {
        bool showDot = _shouldShowDot(value, index);
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: showDot ? Constants.primary : Colors.transparent,
          ),
          width: 8,
          height: 8,
        );
      }),
    );
  }

  bool _shouldShowDot(int value, int position) {
    // Posições: 0,1,2 (top), 3,4,5 (middle), 6,7,8 (bottom)
    switch (value) {
      case 1:
        return position == 4; // center
      case 2:
        return position == 0 || position == 8; // top-left, bottom-right
      case 3:
        return position == 0 || position == 4 || position == 8; // diagonal
      case 4:
        return position == 0 ||
            position == 2 ||
            position == 6 ||
            position == 8; // corners
      case 5:
        return position == 0 ||
            position == 2 ||
            position == 4 ||
            position == 6 ||
            position == 8; // corners + center
      case 6:
        return position == 0 ||
            position == 2 ||
            position == 3 ||
            position == 5 ||
            position == 6 ||
            position == 8; // sides
      default:
        return false;
    }
  }
}
