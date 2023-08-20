import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import '../model/document.dart';
import '../services/database_helper.dart';
import '../utils/save_image_path.dart';
import '../utils/utils.dart';

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
  Future<bool> performDocumentScan(BuildContext context) async{
    try {
      final scannedImages = await CunningDocumentScanner.getPictures();
      if (scannedImages != null) {
        for (var image in scannedImages) {
          File file = File(image);
          final modifiedDate = await file.lastModified();
          print(modifiedDate.toIso8601String());
          String uri = await ImageProperties.saveImageFromPath(image);
          final name = await ImageProperties.getName(image);
          Document newDoc = Document(
              id: 0,
              uri: uri,
              name: name,
              timeStamp: modifiedDate.toIso8601String());
          addDocument(newDoc);
        }
        print(scannedImages);
      }
      return true;
    } catch (exception) {
      Utils.showErrorMessage(context, exception.toString());
      return false;
    }
  }

}