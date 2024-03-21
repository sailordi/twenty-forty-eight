import 'package:flutter/material.dart';
import '../model/gameInfo.dart';

class BigButton extends StatelessWidget {
  final String label;
  final Color color;
  final void Function() onPressed;

  const BigButton({super.key, required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
      height: 80,
      width: 400,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GameInfo.cornerRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700)),
      ));
}