import 'package:flutter/material.dart';
import 'package:guaxilist/data/repositories/game_repository.dart';
import 'package:guaxilist/data/repositories/sqlite_game_repository.dart';
import 'package:guaxilist/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        useMaterial3: true,
      ),
      home: SplashScreen(gameRepository: gameRepository),
    );
  }
}
