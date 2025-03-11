// import 'package:flutter/material.dart';
// import 'package:re_dice/app/model/dice.dart';
// import 'package:shake_detector/shake_detector.dart';
// // import 'package:shake/shake.dart';
// // import 'package:shake_gesture/shake_gesture.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//   int value = 0;
//   late AnimationController _shakeController;
//   final Dice _dice = Dice(id: 1, sides: 6);
//   final Dice _dice2 = Dice(id: 2, sides: 18);
//   final Dice _dice3 = Dice(id: 3, sides: 24);
//   final List<Dice> _diceList = <Dice>[];

//   @override
//   void initState() {
//     _diceList.addAll([_dice, _dice2, _dice3]);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: const Text('Home')), body: body());
//   }

//   Widget body() {
//     return ShakeDetectWrap(
//       enabled: true,
//       onShake: _increment,
//       child: Center(
//         child: Column(
//           children: [
//             Text('[${_dice.selectedValue}]', style: textStyle()),
//             Text('[${_dice2.selectedValue}]', style: textStyle()),
//             Text('[${_dice3.selectedValue}]', style: textStyle()),
//           ],
//         ),
//       ),
//     );
//   }

//   void _increment() {
//     setState(() {
//       int total = _diceList.rollAll();
//       print('Dice rolled: $total');

//       // print('Dice rolled: ${_diceList.map((d) => d.selectedValue).toList()}');
//     });
//   }

//   TextStyle textStyle() {
//     return const TextStyle(fontSize: 48);
//   }
// }
