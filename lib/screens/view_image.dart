import 'package:flutter/material.dart';
import '../../model/document.dart';
import 'dart:io';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.document});

  final Document? document;
  static const String id = "View_Image";


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(document!.name),
      ),
      body: Center(
        child: Image.file(
          File(document!.uri),
          width: screenSize.width,
        ),
      ),
    );
  }
}
