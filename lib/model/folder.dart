import 'document.dart';

class Folder{
  late String name;
  late DateTime modified;
  late List<Document> documents;

  Folder(){
    name = "New Folder";
    modified = DateTime.now();
    documents = [];
  }
}