import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/document.dart';

class DatabaseHelper{
  late Database? database;
  static const int _version = 1;
  static const String databaseName = "Scanner.db";


  static Future<Database> _getDatabase() async{
    print("Connecting to database");
    return openDatabase(
    join(await getDatabasesPath(), databaseName),
    version: _version,
    onCreate: (db, version) => db.execute("CREATE TABLE Document ("
        "id varchar(255), "
        "uri varchar(255), "
        "name varchar(255), "
        "timeStamp varchar(255)"
        ");"),
    );
  }

  Future<Database> _initState() async => database = await _getDatabase();

  DatabaseHelper(){
    print("database file created");
    _initState();
  }

  Future<int> insert(Document document) async {
    try{
      Database db = await _getDatabase();
      if(db!=null){
        return await database!.insert('Document', document.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }else{
        throw DatabaseException;
      }
    }catch(e){
      print(e.toString());
      return 0;
    }
  }

  Future<List<Document>> getAll() async{
    try{
      Database db = await _getDatabase();
      final List<Map<String,dynamic>> maps = await database!.query("Document");
      if(maps.isEmpty){
        print("I am empty");
        return [];
      }
      print("Returning the list of documents");
      return List.generate(maps.length, (index) => Document.fromJson(maps[index]));
      return [];
    }catch(e){
      print(e.toString());
      return [];
    }
  }

}