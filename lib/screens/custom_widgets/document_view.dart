import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:material_scanner/screens/view_image.dart';
import 'package:provider/provider.dart';
import '../../model/document.dart';
import '../../viewModel/image_view_model.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key, required this.document});

  final Document document;
  static const listImageSize = 56.0;

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {

  late File file;
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
    dateTime = DateTime.parse(widget.document.timeStamp);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => ViewImage(document: widget.document)));
      },

      leading: Hero(
            tag: "ScannedImage_${widget.document.uri}",
            child: Image.file(
                file,
                height: DocumentView.listImageSize,
                width: DocumentView.listImageSize,
              ),
          ),
      title: Text(
        widget.document.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Photo"),
          Text("Added: ${DateFormat.yMMMMd().format(dateTime)}"),
        ],
      ),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,

        onSelected: (value) async {
          print(value);
          if(value == "delete"){
            setState(() {
              Provider.of<ImageViewModel>(context,listen: false).deleteDocument(widget.document);
            });
          }
        },
        itemBuilder: (context) => <PopupMenuItem<String>>[
          const PopupMenuItem(
            value: "delete",
            padding: EdgeInsets.zero,
            child: Row(
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

