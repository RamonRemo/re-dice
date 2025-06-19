import 'package:flutter/material.dart';
import 'package:re_dice/app/utils/constants.dart';

class MatrixButton extends StatelessWidget {
  final Function()? onPressed;
  final String? label;

  const MatrixButton({super.key, this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label ?? '',
        style: TextStyle(fontSize: 30, color: Constants.primary),
      ),
    );
  }
}
