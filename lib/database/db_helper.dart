import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pet_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pets.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        photo TEXT,
        breed TEXT,
        color TEXT,
        date_of_birth TEXT,
        additional_details TEXT,
        vaccine_dates TEXT
      );
    ''');
  }

  Future<int> insertPet(Pet pet) async {
    final db = await database;
    return await db.insert('pets', pet.toMap());
  }

  Future<int> updatePet(Pet pet) async {
    final db = await database;
    return await db.update(
      'pets',
      pet.toMap(),
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  Future<List<Pet>> fetchPets() async {
    final db = await database;
    final maps = await db.query('pets');

    return List.generate(maps.length, (i) {
      return Pet.fromMap(maps[i]);
    });
  }

  Future<int> deletePet(int id) async {
    final db = await database;
    return await db.delete(
      'pets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}