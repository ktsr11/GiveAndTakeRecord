import 'dart:io';

import 'package:giv_tak_rec/model/personal_unit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String table = 'register';
final String _databaseName = "givtakDB.db";
final int _databaseVersion = 1;

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db; 

  //해당 변수에 데이터 베이스 정보를 담을것이다. 
  static Database _database; 

  static final columnId    = '_id';
  static final columnTitle    = 'title';
  static final columnName    = 'name';
  static final columnAmt    = 'amt';
  static final columnPhone    = 'phone';
  static final columnDate    = 'date';

  //생성된 데이터베이스가 있다면 _databse 를 리턴하고 
  //없다면 데이터베이스를 생성하여 리턴한다. 
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB(); 
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NULL,
            $columnName TEXT NULL,
            $columnAmt INTEGER NULL,
            $columnPhone TEXT NULL,
            $columnDate TEXT NULL
          )
        ''');
      },
    );
  }

  //인서트 
  createData(PersonalUnit person) async {
    final db = await database;
    var res = await db.insert(table, person.toJson());
    return res;
  }

  //단건 가져오기 
  getPersonal(int id) async {
    final db = await database;
    var res = await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    return res.isNotEmpty ? PersonalUnit.fromJson(res.first) : Null;
  }

  //모든 데이터 가져오기 
  getListPersonUnit() async {
    final db = await database; 
    var res = await db.query(table);
    List<PersonalUnit> list = res.isNotEmpty ? res.map((c) => PersonalUnit.fromJson(c)).toList() : [];
    return list;
  }

  //Update PersonalUnit 
  updatePerson(PersonalUnit person) async {
    final db = await database;
    var res = await db.update(table, person.toJson(), where: '$columnId =?', whereArgs: [person.id]);
    return res;
  }

  //Delete PersonalUnit 
  deletePerson(int id) async {
    final db = await database; 
    db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //Delete All Person 
  deletaAllPerson() async {
    final db = await database;
    db.rawDelete('DELETE * FROM $table');
  }
}