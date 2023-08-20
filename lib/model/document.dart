
class Document{
  late int id;
  late String uri;
  late String name;
  late String timeStamp;


  Document({required this.id ,required this.uri, required this.name, required this.timeStamp});

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'],
    uri: json['uri'],
    name: json['name'],
    timeStamp: json['timeStamp']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'uri': uri,
      'name': name,
      'timeStamp': timeStamp,
    };

    if (id != 0) {
      data['id'] = id;
    }

    return data;
  }
}