import 'package:flutter/material.dart';
import '../model/document.dart';
import '../services/database_helper.dart';

class ImageViewModel extends ChangeNotifier{
  bool _loading = false;
  List<Document> documentList = [];
  late DatabaseHelper dbHelper;

  ImageViewModel(){
    dbHelper = DatabaseHelper();
    loadDocuments();
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  Future<bool> addDocument(Document document)async{
    documentList.add(document);
    await dbHelper.insert(document);
    notifyListeners();
    return true;
  }

  Future<void> loadDocuments() async {
    documentList = await dbHelper.getAll();
    notifyListeners();
  }


}