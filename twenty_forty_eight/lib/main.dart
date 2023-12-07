import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twenty_forty_eight/bloc/game_bloc.dart';
import 'package:twenty_forty_eight/screens/home/HomeView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255,250,248,239),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: const HomeView(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
