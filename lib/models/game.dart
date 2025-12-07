import 'package:guaxilist/models/game_status.dart';

class Game {
  static const _undefined = Object();

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
    Object? imageUrl = _undefined,
    List<String>? tags,
    Object? publishedAt = _undefined,
    GameStatus? status,
    List<String>? platforms,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl == _undefined ? this.imageUrl : imageUrl as String?,
      tags: tags ?? this.tags,
      publishedAt: publishedAt == _undefined
          ? this.publishedAt
          : publishedAt as DateTime?,
      status: status ?? this.status,
      platforms: platforms ?? this.platforms,
    );
  }
}
