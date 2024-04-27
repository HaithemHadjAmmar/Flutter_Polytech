// ignore_for_file: file_names

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Database? _database;
  static const String _tableName = 'etudiant';

  // Method to initialize the database
  static Future<void> _initDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'etudiant_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
          );
        },
        version: 1,
      );
    }
  }

  // Method to insert a new etudiant
  static Future<void> insertEtudiant(Etudiant etudiant) async {
    await _initDatabase();
    await _database?.insert(
      _tableName,
      etudiant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to retrieve all etudiants
  static Future<List<Etudiant>> getAllEtudiants() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(_tableName);
    return List.generate(maps.length, (i) {
      return Etudiant(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  // Method to update an existing etudiant
  static Future<void> updateEtudiant(Etudiant etudiant) async {
    await _initDatabase();
    await _database?.update(
      _tableName,
      etudiant.toMap(),
      where: 'id = ?',
      whereArgs: [etudiant.id],
    );
  }

  // Method to delete an etudiant
  static Future<void> deleteEtudiant(int id) async {
    await _initDatabase();
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Etudiant {
  final int id;
  final String name;
  final int age;

  Etudiant({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
