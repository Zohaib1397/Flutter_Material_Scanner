import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../../model/document.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

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
        onTap: (value) async {
          if(value == 0){
            await Share.shareXFiles([XFile(file.path)]);
          }
          else if(value == 1){
            await GallerySaver.saveImage(file.path);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Saved Successfully")));
          }
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
