import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../managers/boardManager.dart';

class ScoreWidget extends ConsumerWidget {
  const ScoreWidget({super.key});

  dynamic _score(String label,String score,{EdgeInsets? padding}) {
    Color c = const Color.fromARGB(255,187, 173, 160);

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: c, borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 18.0, color: Color(0xffeee4da) ),
        ),
        Text(
          score,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(boardManager.select((board) => board.score) );
    final best = ref.watch(boardManager.select((board) => board.bestScore) );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _score('Score','$score'),
        const SizedBox(
          width: 8.0,
        ),
        _score('Best','$best',padding:const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0) ),
      ],
    );

  }

}
