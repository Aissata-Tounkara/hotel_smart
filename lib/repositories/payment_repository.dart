import '../database/database_helper.dart';
import '../models/paiement.dart';
import '../utils/constants.dart';

/// Acces aux donnees SQLite de la table `payments`.
class PaymentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(Paiement paiement) async {
    final db = await _dbHelper.database;
    return db.insert(AppConstants.tablePayments, paiement.toMap()..remove('id'));
  }

  Future<Paiement?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tablePayments, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Paiement.fromMap(rows.first);
  }

  Future<List<Paiement>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tablePayments, orderBy: 'date_paiement DESC');
    return rows.map(Paiement.fromMap).toList();
  }

  Future<List<Paiement>> getByReservation(int reservationId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      AppConstants.tablePayments,
      where: 'reservation_id = ?',
      whereArgs: [reservationId],
      orderBy: 'date_paiement DESC',
    );
    return rows.map(Paiement.fromMap).toList();
  }

  Future<int> update(Paiement paiement) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tablePayments,
      paiement.toMap(),
      where: 'id = ?',
      whereArgs: [paiement.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(AppConstants.tablePayments, where: 'id = ?', whereArgs: [id]);
  }
}
