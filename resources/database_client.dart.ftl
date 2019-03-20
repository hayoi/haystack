import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  static final DatabaseClient _singleton = new DatabaseClient._internal();

  factory DatabaseClient() {
    return _singleton;
  }

  DatabaseClient._internal() {
    create().then((d) {
      _db = d;
    });
  }

  Database _db;

  Future<Database> get db async{
    if (_db == null) {
      await create();
    }
    return _db;
  }

  Future<Database> create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbPath = join(path.path, "charging_db.db");

    return openDatabase(dbPath, version: 9, onUpgrade: (d, o, n) {
    }, onOpen: (d) {
    });
  }
}
