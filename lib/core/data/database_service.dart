import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class DataBaseService {
  static Database? _database;

  static final DataBaseService db = DataBaseService._internal();

  static const _dataBaseVersion = 1;

  factory DataBaseService() {
    return db;
  }

  DataBaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Path where is store the data base
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = p.join(documentDirectory.path, 'InsttantDataBase.db');

    return await openDatabase(path, version: _dataBaseVersion, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      Batch batch = db.batch();

      batch.execute('''
            CREATE TABLE Contacts(
              Id INTEGER PRIMARY KEY AUTOINCREMENT,              
              Name TEXT NOT NULL,
              Phone INTEGER NOT NULL
            );
        ''');

      batch.commit();
    });
  }
}
