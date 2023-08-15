import 'dart:io';

import 'package:flutter/material.dart';
import '../../Structure/document.dart';

class DocumentView extends StatelessWidget {
  const DocumentView({super.key, this.document});

  final Document? document;
  static const listImageSize = 56.0;

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
              document!=null? Image.file(File(document!.picture.uri),height: listImageSize, width: listImageSize,):
              const Image(image: NetworkImage("https://picsum.photos/600"),height: listImageSize, width: listImageSize,),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document?.picture.name?? "IMG_3341", style: const TextStyle(fontWeight: FontWeight.bold),),
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
