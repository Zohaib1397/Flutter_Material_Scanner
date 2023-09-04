import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/document.dart';
import '../services/database_helper.dart';
import '../utils/save_image_path.dart';
import '../utils/utils.dart';

class ImageViewModel extends ChangeNotifier{
  bool _loading = false;
  List<Document> documentList = [];
  late DatabaseHelper dbHelper;

  ImageViewModel(){
    _loading = true;
    dbHelper = DatabaseHelper.instance;
    loadDocuments();
    _loading = false;
    notifyListeners();
  }

  //Check if the loading is false and list is still empty then
  // return true indicating there is no data
  bool isEmpty() {
    return documentList.isEmpty && !_loading? true : false;
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
  }

  Future<bool> addDocument(Document document)async{
    _loading = true;
    await dbHelper.insert(document);
    await loadDocuments();
    _loading = false;
    notifyListeners();
    return true;
  }

  Future<void> loadDocuments() async {
    _loading = true;
    documentList = await dbHelper.getAll();
    loading = false;
    notifyListeners();
  }

  Future<bool> deleteDocument(Document document) async{
    try{
      _loading = true;
      documentList.remove(document);
      print("Deletion Status: ${await dbHelper.delete(document)}");
      File file = File(document.uri);
      await file.delete();
      _loading = false;
      notifyListeners();
      return true;
    }catch(e){
      print(e.toString());
      _loading = false;
      return false;
    }
  }
  Future<bool> performDocumentScan(BuildContext context) async{
    try {
      _loading = true;
      final scannedImages = await CunningDocumentScanner.getPictures();
      if (scannedImages != null) {
        for (var image in scannedImages) {
          File file = File(image);
          final modifiedDate = await file.lastModified();
          print(modifiedDate.toIso8601String());
          String uri = await ImageProperties.saveImageFromPath(image);
          Document newDoc = Document(
              id: 0,
              uri: uri,
              name: "IMG_${modifiedDate.year}${modifiedDate.day}${modifiedDate.month}_${modifiedDate.hour}${modifiedDate.minute}${modifiedDate.second}",
              timeStamp: modifiedDate.toIso8601String());
          addDocument(newDoc);
        }
        print(scannedImages);
      }
      _loading = false;
      return true;
    } catch (exception) {
      _loading = false;
      Utils.showErrorMessage(context, exception.toString());
      return false;
    }
  }

  Future<bool> importFromCameraRoll(BuildContext context, XFile image) async{
    try{
      _loading = true;
      final modifiedDate = await image.lastModified();
      String uri = await ImageProperties.saveImageFromPath(image.path);
      Document newDoc = Document(
        id: 0,
        uri: uri,
        name: "IMG_${modifiedDate.year}${modifiedDate.day}${modifiedDate.month}_${modifiedDate.hour}${modifiedDate.minute}${modifiedDate.second}",
        timeStamp: modifiedDate.toIso8601String()
      );
      addDocument(newDoc);
      _loading = false;
      return true;
    }catch(e){
      _loading = false;
      Utils.showErrorMessage(context, e.toString());
      return false;
    }
  }

  Future<bool> updateImageDocument(BuildContext context, Document document) async{
    try{
      _loading = true;
      dbHelper.update(document);
      loadDocuments();
      _loading = false;
      notifyListeners();
      return true;
    }catch(e){
      Utils.showErrorMessage(context, e.toString());
      return false;
    }
  }

}