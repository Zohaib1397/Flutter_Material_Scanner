import 'package:flutter/material.dart';
import '../model/document.dart';
import 'dart:io';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key, required this.document});

  final Document document;

  static const String id = "EditImageScreen";

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  late File file;
  bool filterToggle = false;
  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.save)),
        ],
      ),
      body: Center(
        child: Image.file(
          file,
          width: screenSize.width,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
        onDestinationSelected: (value){
          if(value == 0){

          }
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.photo_filter), label: "Filter", tooltip: "Filter Image"),
          NavigationDestination(icon: Icon(Icons.crop_rotate), label: "Adjust", tooltip: "Crop and Rotate"),
          NavigationDestination(icon: Icon(Icons.add_reaction_outlined), label: "Emoji", tooltip: "Add Emoji"),
        ],
      ),
    );
  }
}
