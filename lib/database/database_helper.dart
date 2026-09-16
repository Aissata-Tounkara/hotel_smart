import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/constants.dart';

/// Singleton responsable de l'ouverture et de la creation de la base
/// SQLite. Toutes les tables et index sont crees ici ; les repositories
/// n'ouvrent jamais la base eux-memes, ils passent par [database].
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'hotel_smart.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tableClients} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        telephone TEXT NOT NULL,
        email TEXT NOT NULL,
        nationalite TEXT NOT NULL,
        cin TEXT,
        date_creation TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tableUsers} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        mot_de_passe_hache TEXT NOT NULL,
        role TEXT NOT NULL,
        client_id INTEGER,
        date_creation TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES ${AppConstants.tableClients} (id)
          ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tableRooms} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL UNIQUE,
        type TEXT NOT NULL,
        prix_par_nuit REAL NOT NULL,
        statut TEXT NOT NULL,
        description TEXT,
        etage INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tableReservations} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        room_id INTEGER NOT NULL,
        date_arrivee TEXT NOT NULL,
        date_depart TEXT NOT NULL,
        statut TEXT NOT NULL,
        montant_total REAL NOT NULL,
        date_creation TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES ${AppConstants.tableClients} (id)
          ON DELETE CASCADE,
        FOREIGN KEY (room_id) REFERENCES ${AppConstants.tableRooms} (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tablePayments} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reservation_id INTEGER NOT NULL,
        montant REAL NOT NULL,
        statut TEXT NOT NULL,
        methode TEXT NOT NULL,
        date_paiement TEXT NOT NULL,
        FOREIGN KEY (reservation_id) REFERENCES ${AppConstants.tableReservations} (id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.tableNotifications} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reservation_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        titre TEXT NOT NULL,
        message TEXT NOT NULL,
        date_alerte TEXT NOT NULL,
        lue INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (reservation_id) REFERENCES ${AppConstants.tableReservations} (id)
          ON DELETE CASCADE
      )
    ''');

    // Index sur les cles etrangeres pour optimiser les jointures/filtrages.
    await db.execute(
        'CREATE INDEX idx_users_client_id ON ${AppConstants.tableUsers} (client_id)');
    await db.execute(
        'CREATE INDEX idx_reservations_client_id ON ${AppConstants.tableReservations} (client_id)');
    await db.execute(
        'CREATE INDEX idx_reservations_room_id ON ${AppConstants.tableReservations} (room_id)');
    await db.execute(
        'CREATE INDEX idx_reservations_dates ON ${AppConstants.tableReservations} (date_arrivee, date_depart)');
    await db.execute(
        'CREATE INDEX idx_payments_reservation_id ON ${AppConstants.tablePayments} (reservation_id)');
    await db.execute(
        'CREATE INDEX idx_notifications_reservation_id ON ${AppConstants.tableNotifications} (reservation_id)');

    await _insertDefaultAdmin(db);
  }

  /// Cas limite (point 38 du cahier des charges) : la base est toujours
  /// creee avec un compte Admin par defaut afin de ne jamais bloquer
  /// l'acces a l'application.
  Future<void> _insertDefaultAdmin(Database db) async {
    final hache = sha256.convert(utf8.encode(AppConstants.defaultAdminPassword)).toString();
    await db.insert(AppConstants.tableUsers, {
      'nom': AppConstants.defaultAdminName,
      'email': AppConstants.defaultAdminEmail,
      'mot_de_passe_hache': hache,
      'role': 'admin',
      'client_id': null,
      'date_creation': DateTime.now().toIso8601String(),
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
