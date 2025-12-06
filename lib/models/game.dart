import 'package:guaxilist/models/game_status.dart';

class Game {
  final String id;
  final String title;
  final String? imageUrl;
  final List<String> tags;
  final DateTime? publishedAt;
  final GameStatus status;
  final List<String> platforms;

  Game({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.tags,
    this.publishedAt,
    required this.status,
    required this.platforms,
  });

  Game copyWith({
    String? id,
    String? title,
    String? imageUrl,
    List<String>? tags,
    DateTime? publishedAt,
    GameStatus? status,
    List<String>? platforms,
  }) {
    return Game(
      id: this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      publishedAt: publishedAt ?? this.publishedAt,
      status: status ?? this.status,
      platforms: platforms ?? this.platforms,
    );
  }
}
