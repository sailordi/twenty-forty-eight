import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twenty_forty_eight/models/gameInfo.dart';

class ButtonWidget extends ConsumerWidget {
  final String? text;
  final VoidCallback onPressed;

  const ButtonWidget(
      {super.key, this.text,required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(16.0)),
            backgroundColor: MaterialStateProperty.all<Color>(GameInfo.buttonColor) ,
        ),
        onPressed: onPressed,
        child: Text(
          text!,
          style: const TextStyle(color: GameInfo.textColorWhite,fontWeight: FontWeight.bold, fontSize: 18.0),
        ));
  }
}