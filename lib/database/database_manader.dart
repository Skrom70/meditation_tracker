import 'package:flutter/material.dart';
import 'package:meditation_tracker/database/database_session.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  late Database db;

  final tableName = 'Sessions';

  Future<void> open() async {
    db = await openDatabase('meditation_tracker.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      durationMins INTEGER,
      dateString TEXT
      )''');
    });
  }

  Future<List<DatabaseSession>> getAll() async {
    await open();
    List<Map> maps = await db.query(tableName, columns: [
      'id',
      'durationMins',
      'dateString',
    ]);
    List<DatabaseSession> records =
        maps.map((e) => DatabaseSession.fromMap(e)).toList();
    return records;
  }

  Future<DatabaseSession?> getItembyId(int id) async {
    await open();
    List<Map> maps = await db.query(tableName,
        columns: [
          'id',
          'durationMins',
          'dateString',
        ],
        where: 'id = $id');
    if (maps.isNotEmpty) {
      return maps.map((e) => DatabaseSession.fromMap(e)).toList().first;
    } else {
      return null;
    }
  }

  Future<DatabaseSession> insert(DatabaseSession databaseSession) async {
    await open();

    databaseSession.id = await db.insert(tableName, databaseSession.toMap());
    return databaseSession;
  }

  Future<DatabaseSession> update(DatabaseSession databaseSession) async {
    if (databaseSession.id != null) {
      await open();

      databaseSession.id = await db.update(tableName, databaseSession.toMap(),
          where: 'id = ${databaseSession.id ?? 0}');
    }
    return databaseSession;
  }

  Future<DatabaseSession> delete(DatabaseSession databaseSession) async {
    if (databaseSession.id != null) {
      await open();
      databaseSession.id =
          await db.delete(tableName, where: 'id = ${databaseSession.id ?? 0}');
    }
    return databaseSession;
  }

  Future<void> deleteAll() async {
    try {
      await open();
      await db.execute('DELETE FROM $tableName');
    } catch (e) {
      ErrorHint('An error has occurred');
    }
  }

  Future<void> close() async {
    await db.close();
  }
}
