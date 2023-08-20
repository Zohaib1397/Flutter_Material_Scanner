import 'package:flutter/material.dart';
import '../model/document.dart';
import '../services/database_helper.dart';

class ImageViewModel extends ChangeNotifier{
  bool _loading = false;
  List<Document> documentList = [];
  late DatabaseHelper dbHelper;

  ImageViewModel(){
    dbHelper = DatabaseHelper.instance;
    loadDocuments();
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  Future<bool> addDocument(Document document)async{
    await dbHelper.insert(document);
    await loadDocuments();
    notifyListeners();
    return true;
  }

  Future<void> loadDocuments() async {
    documentList = await dbHelper.getAll();
    notifyListeners();
  }

  Future<bool> deleteDocument(Document document) async{
    try{
      documentList.remove(document);
      print("Deletion Status: ${await dbHelper.delete(document)}");
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }


}