// ignore_for_file: file_names

import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class SqlHelper {
  static const String _databaseName = 'contacts.db';
  static const String _tableName = 'contacts';
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
        // Create table statement with necessary columns (id, name, phone)
        db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Method to insert a new contact
  static Future<void> insertContact(List<Contact> contacts) async {
    await _initDatabase();
    final batch = _database!.batch();
    for (final contact in contacts) {
      batch.insert(_tableName, contact.toMap());
    }
    await batch.commit();
  }

  // Method to get all contacts
  static Future<List<Contact>> getAllContacts() async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(_tableName);
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Method to update an existing contact
  static Future<void> updateContact(Contact contact) async {
    await _initDatabase();
    await _database!.update(
      _tableName,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Method to delete a contact
  static Future<void> deleteContact(int id) async {
    await _initDatabase();
    await _database!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Method to search contacts by name or phone number
  static Future<List<Contact>> searchContacts(String query) async {
    await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      _tableName,
      where: 'name LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Method to call a contact
  static Future<void> callContact(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}

class Contact {
  final int id;
  final String name;
  final String phone;

  const Contact({
    required this.id,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }
}
