import '../database/database_helper.dart';
import '../models/notification_alerte.dart';
import '../utils/constants.dart';

/// Acces aux donnees SQLite de la table `notifications`.
class NotificationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(NotificationAlerte notification) async {
    final db = await _dbHelper.database;
    return db.insert(AppConstants.tableNotifications, notification.toMap()..remove('id'));
  }

  Future<List<NotificationAlerte>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableNotifications, orderBy: 'date_alerte DESC');
    return rows.map(NotificationAlerte.fromMap).toList();
  }

  Future<List<NotificationAlerte>> getUnread() async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      AppConstants.tableNotifications,
      where: 'lue = 0',
      orderBy: 'date_alerte DESC',
    );
    return rows.map(NotificationAlerte.fromMap).toList();
  }

  Future<int> markAsRead(int id) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableNotifications,
      {'lue': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(AppConstants.tableNotifications, where: 'id = ?', whereArgs: [id]);
  }
}
