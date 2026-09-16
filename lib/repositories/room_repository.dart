import '../database/database_helper.dart';
import '../models/chambre.dart';
import '../utils/constants.dart';

/// Acces aux donnees SQLite de la table `rooms`.
class RoomRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(Chambre chambre) async {
    final db = await _dbHelper.database;
    return db.insert(AppConstants.tableRooms, chambre.toMap()..remove('id'));
  }

  Future<Chambre?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableRooms, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Chambre.fromMap(rows.first);
  }

  Future<List<Chambre>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableRooms, orderBy: 'numero ASC');
    return rows.map(Chambre.fromMap).toList();
  }

  Future<int> update(Chambre chambre) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableRooms,
      chambre.toMap(),
      where: 'id = ?',
      whereArgs: [chambre.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(AppConstants.tableRooms, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> numeroExists(String numero, {int? excludeId}) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      AppConstants.tableRooms,
      where: excludeId != null ? 'numero = ? AND id != ?' : 'numero = ?',
      whereArgs: excludeId != null ? [numero, excludeId] : [numero],
    );
    return rows.isNotEmpty;
  }
}
