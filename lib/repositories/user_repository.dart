import '../database/database_helper.dart';
import '../models/utilisateur.dart';
import '../utils/constants.dart';

/// Acces aux donnees SQLite de la table `users`.
/// Aucune logique metier ici (le hachage du mot de passe est gere par
/// `AuthService`) : uniquement des operations CRUD brutes.
class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(Utilisateur user) async {
    final db = await _dbHelper.database;
    return db.insert(AppConstants.tableUsers, user.toMap()..remove('id'));
  }

  Future<Utilisateur?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableUsers, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Utilisateur.fromMap(rows.first);
  }

  Future<Utilisateur?> getByEmail(String email) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      AppConstants.tableUsers,
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    if (rows.isEmpty) return null;
    return Utilisateur.fromMap(rows.first);
  }

  Future<List<Utilisateur>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableUsers, orderBy: 'nom ASC');
    return rows.map(Utilisateur.fromMap).toList();
  }

  Future<int> update(Utilisateur user) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableUsers,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(AppConstants.tableUsers, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> emailExists(String email, {int? excludeId}) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      AppConstants.tableUsers,
      where: excludeId != null ? 'email = ? AND id != ?' : 'email = ?',
      whereArgs: excludeId != null ? [email.trim().toLowerCase(), excludeId] : [email.trim().toLowerCase()],
    );
    return rows.isNotEmpty;
  }
}
