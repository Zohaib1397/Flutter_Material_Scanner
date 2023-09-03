import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageTextScreen extends StatefulWidget {
  final Uint8List imageMemory;
  const ImageTextScreen({super.key, required this.imageMemory});

  static const String id = "Image_Text_Screen";
  @override
  State<ImageTextScreen> createState() => _ImageTextScreenState();
}

class _ImageTextScreenState extends State<ImageTextScreen> {
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Text")
        ),
        body: Column(
          children: [


          ],
        ),
      ),
    );
  }
}
