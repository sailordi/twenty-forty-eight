import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'adapter/gameDataAdapter.dart';
import 'package:twenty_forty_eight/view/home/homeView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Make sure Hive is initialized first and only after register the adapter.
  await Hive.initFlutter();
  Hive.registerAdapter(GameDataAdapter() );

  runApp(const ProviderScope(
    child: MaterialApp(
      title: '2048',
      home: HomeView(),
      debugShowCheckedModeBanner: false,
    ),
  ));

}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
*/