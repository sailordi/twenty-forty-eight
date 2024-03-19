import 'package:flutter/material.dart';

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/gameBloc.dart';
import 'package:twenty_forty_eight/model/Tile.dart';
import 'package:twenty_forty_eight/model/GameInfo.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  void saveGameState(GameState gameState) async {
    final prefs = await SharedPreferences.getInstance();
    String gameStateJson = json.encode(gameState.toJson());

      await prefs.setString('gameState', gameStateJson);
  }

  Future<GameState?> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();

    String? gameStateJson = prefs.getString('gameState');

    if (gameStateJson != null) {
      return GameState.fromJson(json.decode(gameStateJson));
    }
    
    return null;
  }

  void _initGrid(GameState state) {

  }

  void _newGame(GameState state) {
    BlocProvider.of<GameBloc>(context).add(RestartGame() );
    _initGrid(state);
  }

  @override
  Widget build(BuildContext context) {
    final info = GameInfo(context);
    return Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              _initGrid(state);
              return const Column(
                children: [
                  Text("TMP"),
                ]
              );
            }
        )
    );
  }

}