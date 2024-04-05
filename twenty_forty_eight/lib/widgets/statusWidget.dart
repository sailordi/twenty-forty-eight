import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twenty_forty_eight/models/gameData.dart';

import '../managers/boardManager.dart';

class StatusWidget extends ConsumerWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(boardManager);

    if(data.status == GameStatus.playing) {
      return Container();
    }
    const TextStyle style = TextStyle(fontSize: 20,fontWeight: FontWeight.bold);

    if(data.status == GameStatus.won) {
      return const Text("You have won",style: style);
    }
    return const Text("You have lost",style: style);

  }
}