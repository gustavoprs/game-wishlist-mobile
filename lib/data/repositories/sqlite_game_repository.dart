import 'package:guaxilist/data/database/app_database.dart';
import 'package:guaxilist/data/repositories/game_repository.dart';
import 'package:guaxilist/models/game.dart';
import 'package:sqflite/sqflite.dart';

class SqliteGameRepository implements GameRepository {
  Future<Database> get _db async {
    return AppDatabase.instance.database;
  }

  @override
  Future<List<Game>> getAll() async {
    final db = await _db;
    final rows = await db.query('games', orderBy: 'title ASC');

    return rows.map((row) => Game.fromMap(row)).toList();
  }

  @override
  Future<Game?> getById(String id) async {
    final db = await _db;
    final rows = await db.query(
      'games',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return Game.fromMap(rows.first);
  }

  @override
  Future<void> insert(Game game) async {
    final db = await _db;

    await db.insert(
      'games',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(Game game) async {
    final db = await _db;

    await db.update(
      'games',
      game.toMap(),
      where: 'id = ?',
      whereArgs: [game.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    await db.delete('games', where: 'id = ?', whereArgs: [id]);
  }
}
