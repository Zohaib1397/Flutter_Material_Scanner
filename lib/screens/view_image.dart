import 'package:flutter/material.dart';
import '../../model/document.dart';
import 'dart:io';

class ViewImage extends StatefulWidget {
  const ViewImage({super.key, required this.document});

  final Document? document;
  static const String id = "View_Image";

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {

  late File file;

  @override
  void initState() {
    super.initState();
    file = File(widget.document!.uri);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document!.name),
      ),
      body: Center(
        child: Hero(
          tag: "ScannedImage_${widget.document!.uri}",
          child: Image.file(
            file,
            width: screenSize.width,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (value){
          print(value);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.share), label: "", tooltip: "Share"),
          BottomNavigationBarItem(icon: Icon(Icons.save),label: "", tooltip: "Save Image"),
          BottomNavigationBarItem(icon: Icon(Icons.delete),label: "", tooltip: "Delete"),
        ],
      ),
    );
  }
}
