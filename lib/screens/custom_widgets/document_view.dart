import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,12,12,12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              widget.document!=null? Image.file(File(widget.document!.uri) ,height: DocumentView.listImageSize, width: DocumentView.listImageSize,):
              const Image(image: NetworkImage("https://picsum.photos/600"),height: DocumentView.listImageSize, width: DocumentView.listImageSize,),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.document?.name?? "IMG_3341", style: const TextStyle(fontWeight: FontWeight.bold),),
                  Text("Photo"),
                  Text("Added: 13th August, 2023"),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: (){},
          ),
        ],
      ),
    );
  }
}
