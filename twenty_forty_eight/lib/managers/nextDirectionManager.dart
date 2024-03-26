import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

/*
If the user swipes too fast we prevent the next round to start until the current round finishes.
That is achieved using the RoundManager.
Instead of canceling that round we will queue it so that the round automatically starts as soon the current finishes:
This will prevent the user feeling like the game is lag-ish or slow.
*/
class NextDirectionManager extends StateNotifier<SwipeDirection?> {
  NextDirectionManager() : super(null);

  void queue(direction) {
    state = direction;
  }

  void clear() {
    state = null;
  }
}

final nextDirectionManager =
StateNotifierProvider<NextDirectionManager, SwipeDirection?>((ref) {
  return NextDirectionManager();
});