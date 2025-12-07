import 'package:guaxilist/models/game.dart';

abstract class GameRepository {
  Future<List<Game>> getAll();

  Future<Game?> getById(String id);

  Future<void> insert(Game game);

  Future<void> update(Game game);

  Future<void> delete(String id);
}
