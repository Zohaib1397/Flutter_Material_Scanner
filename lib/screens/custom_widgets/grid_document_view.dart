import 'package:flutter/material.dart';
import 'dart:io';
import 'package:material_scanner/model/document.dart';

class GridDocumentView extends StatefulWidget {
  final Document document;
  const GridDocumentView({super.key, required this.document});

  @override
  State<GridDocumentView> createState() => _GridDocumentViewState();
}

class _GridDocumentViewState extends State<GridDocumentView> {
  
  late File file;
  
  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
  }
  @override
  Widget build(BuildContext context) {
    return Image.file(file, width: 40, height: 40,);
  }
}
