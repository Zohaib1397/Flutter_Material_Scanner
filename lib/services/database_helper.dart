import 'package:sqflite/sqflite.dart';
import '../model/document.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Scanner.db');
    return _database!;
  }

  Future<Database> _initDB(String databaseName) {
    print("Connecting to Database");
    return openDatabase(
      databaseName, version: _version, onCreate: (db, version) =>
        db.execute("CREATE TABLE Document ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "uri varchar(255), "
            "name varchar(255), "
            "timeStamp varchar(255)"
            ");"),
    );
  }

  static const int _version = 1;

  Future<int> insert(Document document) async {
    try {
      Database db = await instance.database;
        return await db.insert('Document', document.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<List<Document>> getAll() async {
    try {
      Database db = await instance.database;
      final List<Map<String, dynamic>> maps = await db.query("Document");
      if (maps.isEmpty) {
        print("Database list is empty");
        return [];
      }
      print("Database Rows:  ${maps.length}");
      print(maps);
      print("Returning the list of documents");
      return List.generate(maps.length, (index) => Document.fromJson(maps[index]));
    } catch (e) {
      print("${e.toString()} Exception in reading data");
      return [];
    }
  }

  Future<int> delete(Document document) async{
    try{
      Database db = await instance.database;
      print(document.id);
      return await db.delete('Document',where: "id = ?", whereArgs: [document.id]);
    }catch(e){
      print(e.toString());
      return 0;
    }
  }

  Future<int> update(Document document) async{
    try{
      Database db = await instance.database;
      return await db.update('Document', document.toJson(), where: "id = ?", whereArgs: [document.id]);
    }catch(e){
      print(e.toString());
      return 0;
    }
  }

}