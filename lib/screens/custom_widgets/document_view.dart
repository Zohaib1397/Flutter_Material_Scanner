import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_scanner/screens/view_image.dart';
import '../../model/document.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key, this.document});

  final Document? document;
  static const listImageSize = 56.0;

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewImage(document: widget.document)));
      },
      leading: widget.document != null
          ? Image.file(
              File(widget.document!.uri),
              height: DocumentView.listImageSize,
              width: DocumentView.listImageSize,
            )
          : const Image(
              image: NetworkImage("https://picsum.photos/600"),
              height: DocumentView.listImageSize,
              width: DocumentView.listImageSize,
            ),//1ca5204f-896f-44ad-8748-5f9c44bf36bd
      title: Text(
        widget.document?.id.toString() ?? "IMG_3341",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Photo"),
          Text("Added: 13th August, 2023"),
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

