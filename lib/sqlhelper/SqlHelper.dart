// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static const String _databaseName = 'etudiants.db';
  static const String _tableName = 'etudiants';
  static Database? _database;

  // Method to initialize the database
  static Future<void> _initDatabase() async {
    if (_database != null) return;

    final databasePath = await getDatabasesPath();
    final path = '$databasePath/$_databaseName';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Create table statement with necessary columns (id, name, age)
        db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // Method to insert a new etudiant
  static Future<void> insertEtudiant(List<Etudiant> etudiants) async {
    await _initDatabase();
    final batch = _database!.batch();
    for (final etudiant in etudiants) {
      batch.insert(_tableName, etudiant.toMap());
    }
    await batch.commit();
  }

  // Method to get all etudiants
  static Future<List<Etudiant>> getAllEtudiants() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(_tableName);
    return List.generate(maps.length, (i) => Etudiant.fromMap(maps[i]));
  }

  // Method to update an existing etudiant
  static Future<void> updateEtudiant(Etudiant etudiant) async {
    await _initDatabase();
    await _database!.update(
      _tableName,
      etudiant.toMap(),
      where: 'id = ?',
      whereArgs: [etudiant.id],
    );
  }

  // Method to delete an etudiant
  static Future<void> deleteEtudiant(int id) async {
    await _initDatabase();
    await _database!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}

class Etudiant {
  final int id;
  final String name;
  final int age;

  const Etudiant({
    required this.id,
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  factory Etudiant.fromMap(Map<String, dynamic> map) {
    return Etudiant(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }
}
