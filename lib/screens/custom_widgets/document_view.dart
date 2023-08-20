import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:material_scanner/screens/view_image.dart';
import '../../model/document.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key, required this.document});

  final Document document;
  static const listImageSize = 56.0;

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {

  late File file;
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
    dateTime = DateTime.parse(widget.document.timeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewImage(document: widget.document)));
      },
      leading: Hero(
            tag: "ScannedImage_${widget.document.uri}",
            child: Image.file(
                file,
                height: DocumentView.listImageSize,
                width: DocumentView.listImageSize,
              ),
          ),

      title: Text(
        widget.document.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Photo"),
          Text("Added: ${DateFormat.yMMMMd().format(dateTime)}"),
        ],
      ),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (value){
          print(value);
        },
        itemBuilder: (context) => <PopupMenuItem<String>>[
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delete"),
                Icon(Icons.delete),
              ],
            ),
          )
        ],
      ),
    );
  }
}

