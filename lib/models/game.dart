class Game {
  final String title;
  final String imageUrl;
  final List<String> tags;
  final DateTime publishedAt;
  final String status;
  final List<String> platforms;

  Game({
    required this.title,
    required this.imageUrl,
    required this.tags,
    required this.publishedAt,
    required this.status,
    required this.platforms,
  });
}
