import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import '../../model/document.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

import '../utils/utils.dart';
import '../viewModel/image_view_model.dart';

class ViewImage extends StatefulWidget {
  const ViewImage({super.key, required this.document});

  final Document document;
  static const String id = "View_Image";

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {

  late File file;

  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.name),
      ),
      body: Center(
        child: Hero(
          tag: "ScannedImage_${widget.document.uri}",
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Saved Successfully")));
          }
          else if(value == 2){
            Utils.showAlertDialog(context, "Delete Image", "Are you sure you want to delete this image?", "Delete", (){
              Provider.of<ImageViewModel>(context, listen:false).deleteDocument(widget.document);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Deleted Successfully")));
              //Pop the alert dialogue
              Navigator.pop(context);
              //Pop back to previous screen
              Navigator.pop(context);
            });
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
