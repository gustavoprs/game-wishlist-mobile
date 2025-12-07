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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'tags': tags.join(','),
      'published_at': publishedAt?.toIso8601String(),
      'status': status.name,
      'platforms': platforms.join(','),
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] as String,
      title: map['title'] as String,
      imageUrl: map['image_url'] as String?,
      tags:
          (map['tags'] as String?)
              ?.split(',')
              .where((t) => t.isNotEmpty)
              .toList() ??
          [],
      publishedAt: map['published_at'] != null
          ? DateTime.parse(map['published_at'] as String)
          : null,
      status: GameStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => GameStatus.planToPlay,
      ),
      platforms:
          (map['platforms'] as String?)
              ?.split(',')
              .where((p) => p.isNotEmpty)
              .toList() ??
          [],
    );
  }
}
