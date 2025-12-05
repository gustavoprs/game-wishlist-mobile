import 'package:flutter/material.dart';

enum GameStatus {
  planToPlay,
  playing,
  paused,
  finished,
  abandoned;

  static GameStatus fromSlug(String slug) {
    final s = slug.toLowerCase();
    switch (s) {
      case 'plan-to-play':
        return GameStatus.planToPlay;
      case 'playing':
        return GameStatus.playing;
      case 'paused':
        return GameStatus.paused;
      case 'finished':
        return GameStatus.finished;
      case 'abandoned':
        return GameStatus.abandoned;
      default:
        throw ArgumentError.value(slug, 'slug', 'Unknown GameStatus slug');
    }
  }

  static GameStatus? tryParse(String? slug) {
    if (slug == null) return null;
    try {
      return fromSlug(slug);
    } catch (_) {
      return null;
    }
  }
}

extension GameStatusX on GameStatus {
  String get slug {
    switch (this) {
      case GameStatus.planToPlay:
        return 'plan-to-play';
      case GameStatus.playing:
        return 'playing';
      case GameStatus.paused:
        return 'paused';
      case GameStatus.finished:
        return 'finished';
      case GameStatus.abandoned:
        return 'abandoned';
    }
  }

  String displayName([BuildContext? context]) {
    switch (this) {
      case GameStatus.planToPlay:
        return 'Planejo Jogar';
      case GameStatus.playing:
        return 'Jogando';
      case GameStatus.paused:
        return 'Pausado';
      case GameStatus.finished:
        return 'Jogado';
      case GameStatus.abandoned:
        return 'Abandonado';
    }
  }

  Color get color {
    switch (this) {
      case GameStatus.planToPlay:
        return Colors.grey;
      case GameStatus.playing:
        return Colors.blue;
      case GameStatus.paused:
        return Colors.yellow;
      case GameStatus.finished:
        return Colors.green;
      case GameStatus.abandoned:
        return Colors.red;
    }
  }
}
