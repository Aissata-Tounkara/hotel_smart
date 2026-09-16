import '../database/database_helper.dart';
import '../models/reservation.dart';
import '../utils/constants.dart';

/// Acces aux donnees SQLite de la table `reservations`.
class ReservationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> create(Reservation reservation) async {
    final db = await _dbHelper.database;
    return db.insert(AppConstants.tableReservations, reservation.toMap()..remove('id'));
  }

  Future<Reservation?> getById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableReservations, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Reservation.fromMap(rows.first);
  }

  Future<List<Reservation>> getAll() async {
    final db = await _dbHelper.database;
    final rows = await db.query(AppConstants.tableReservations, orderBy: 'date_arrivee DESC');
    return rows.map(Reservation.fromMap).toList();
  }

  Future<List<Reservation>> getByClient(int clientId) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      AppConstants.tableReservations,
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'date_arrivee DESC',
    );
    return rows.map(Reservation.fromMap).toList();
  }

  /// Reservations actives (non annulees) d'une chambre, utilisees pour la
  /// verification de conflit de dates.
  Future<List<Reservation>> getByRoom(int roomId, {int? excludeReservationId}) async {
    final db = await _dbHelper.database;
    final where = excludeReservationId != null
        ? 'room_id = ? AND statut != ? AND id != ?'
        : 'room_id = ? AND statut != ?';
    final args = excludeReservationId != null
        ? [roomId, 'annulee', excludeReservationId]
        : [roomId, 'annulee'];
    final rows = await db.query(AppConstants.tableReservations, where: where, whereArgs: args);
    return rows.map(Reservation.fromMap).toList();
  }

  Future<int> update(Reservation reservation) async {
    final db = await _dbHelper.database;
    return db.update(
      AppConstants.tableReservations,
      reservation.toMap(),
      where: 'id = ?',
      whereArgs: [reservation.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return db.delete(AppConstants.tableReservations, where: 'id = ?', whereArgs: [id]);
  }
}
