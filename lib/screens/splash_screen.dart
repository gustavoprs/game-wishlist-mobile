import 'package:flutter/material.dart';
import 'package:guaxilist/data/repositories/game_repository.dart';
import 'package:guaxilist/screens/home.dart';

class SplashScreen extends StatefulWidget {
  final GameRepository gameRepository;

  const SplashScreen({super.key, required this.gameRepository});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MyHomePage(gameRepository: widget.gameRepository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image,
                size: 72,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(height: 12),
              Text(
                'GuaxiList',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
