import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<GameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
