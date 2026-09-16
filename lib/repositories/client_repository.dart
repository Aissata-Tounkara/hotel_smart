import '../database/database_helper.dart';
import '../models/client.dart';
import '../utils/constants.dart';

/// Acces aux donnees SQLite de la table `clients`.
class ClientRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(Client client) async {
    final db = await _dbHelper.database;
    return db.insert(AppConstants.tableClients, client.toMap()..remove('id'));
  }

  Future<Client?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableClients, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Client.fromMap(rows.first);
  }

  Future<List<Client>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableClients, orderBy: 'nom ASC');
    return rows.map(Client.fromMap).toList();
  }

  Future<List<Client>> search(String query) async {
    final db = await _dbHelper.database;
    final like = '%$query%';
    final rows = await db.query(
      AppConstants.tableClients,
      where: 'nom LIKE ? OR prenom LIKE ? OR telephone LIKE ? OR email LIKE ?',
      whereArgs: [like, like, like, like],
      orderBy: 'nom ASC',
    );
    return rows.map(Client.fromMap).toList();
  }

  Future<int> update(Client client) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableClients,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(AppConstants.tableClients, where: 'id = ?', whereArgs: [id]);
  }
}
