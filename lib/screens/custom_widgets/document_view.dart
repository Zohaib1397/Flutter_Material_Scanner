import 'dart:io';
import 'package:flutter/material.dart';
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
      leading: widget.document!=null? Image.file(File(widget.document!.uri) ,height: DocumentView.listImageSize, width: DocumentView.listImageSize,):
              const Image(image: NetworkImage("https://picsum.photos/600"),height: DocumentView.listImageSize, width: DocumentView.listImageSize,),
      title: Text(widget.document?.name?? "IMG_3341", style: const TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Photo"),
          Text("Added: 13th August, 2023"),
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: (){},
      ),
    );
  }
}
