import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:material_scanner/screens/Image%20Editing%20Screens/edit_image_screen.dart';
import 'package:provider/provider.dart';
import '../../model/document.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../Theme/scanner_theme.dart';
import '../utils/utils.dart';
import '../viewModel/image_view_model.dart';

class ViewImage extends StatefulWidget {
  ViewImage({super.key, required this.document});

  late Document document;
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
    return Theme(
      data: ThemeData.from(
        colorScheme: ScannerTheme().darkColorScheme,
      ),
      child: Scaffold(
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
          type: BottomNavigationBarType.fixed,
          onTap: (value) async {
            if(value == 0){
             final newDoc = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditImageScreen(document: widget.document,)));
             if(newDoc!=null){
              print(newDoc);
               setState(() {
                widget.document = newDoc;
                file = File(widget.document.uri);
               });
             }
            }
            else if(value == 1){
              await Share.shareXFiles([XFile(file.path)]);
            }
            else if(value == 2){
              await GallerySaver.saveImage(file.path);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Saved Successfully")));
            }
            else if(value == 3){
              Utils.showAlertDialog(context,  title: "Delete Image", content:"Are you sure you want to delete this image?", confirmText: "Delete", onConfirm: (){
                Provider.of<ImageViewModel>(context, listen:false).deleteDocument(widget.document);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Deleted Successfully")));
                Navigator.pop(context);
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Edit", tooltip: "Edit Image"),
            BottomNavigationBarItem(icon: Icon(Icons.share), label: "Share", tooltip: "Share"),
            BottomNavigationBarItem(icon: Icon(Icons.save),label: "Save", tooltip: "Save Image"),
            BottomNavigationBarItem(icon: Icon(Icons.delete),label: "Delete", tooltip: "Delete"),
          ],
        ),
      ),
    );
  }
}
