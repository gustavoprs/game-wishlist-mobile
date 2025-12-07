import 'package:flutter/material.dart';
import 'package:guaxilist/data/repositories/game_repository.dart';
import 'package:guaxilist/data/repositories/sqlite_game_repository.dart';
import 'package:guaxilist/screens/home.dart';

Future<void> main() async {
  final GameRepository gameRepository = SqliteGameRepository();

  runApp(MyApp(gameRepository: gameRepository));
}

class MyApp extends StatelessWidget {
  final GameRepository gameRepository;

  const MyApp({super.key, required this.gameRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuaxiList',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {'/': (context) => MyHomePage(gameRepository: gameRepository)},
    );
  }
}
