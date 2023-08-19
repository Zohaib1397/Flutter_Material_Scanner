import 'package:uuid/uuid.dart';

class Document{
  String? id;
  late String uri;
  late String name;
  late String timeStamp;


  Document({this.id ,required this.uri, required this.name, required this.timeStamp}){
    //Uuid package is used to always generate random and unique id for document
     var temp= const Uuid();
     id = temp.v4();
  }

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'],
    uri: json['uri'],
    name: json['name'],
    timeStamp: json['timeStamp']
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'uri': uri,
        'name': name,
        'timeStamp': timeStamp
      };
}