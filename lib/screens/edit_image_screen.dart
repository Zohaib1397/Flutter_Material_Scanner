import 'package:flutter/material.dart';
import 'package:material_scanner/Theme/scanner_theme.dart';
import 'package:photo_view/photo_view.dart';
import '../model/document.dart';
import 'dart:io';

import '../utils/constants.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key, required this.document});

  final Document document;

  static const String id = "EditImageScreen";

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  late File file;
  bool filterToggle = true;
  int bottomBarSwitchPosition = 0;

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
        colorScheme: ScannerTheme().darkColorScheme
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Edit Image"),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: PhotoView.customChild(
                  child: Image.file(
                    file,
                    width: screenSize.width,
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: filterToggle? 80: 0,
              child: Container(
                color: Colors.black,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(),
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: 40,
                  itemBuilder: (context, index) => Image.file(
                    file,
                    width: 60.0,
                    height: 60.0,
                  ),
                ),
              ),
            ),
            BottomNavigationBar(
              backgroundColor: Colors.black,
              onTap: (value) {
                if (value == 0) {
                  setState(() {
                    filterToggle = true;
                    bottomBarSwitchPosition = 0;
                  });
                }
                else if (value == 1){
                  setState(() {
                    filterToggle = false;
                    bottomBarSwitchPosition = 1;
                  });
                }
                else if (value == 2){
                  setState(() {
                    filterToggle = false;
                    bottomBarSwitchPosition = 2;
                  });
                }
              },
              currentIndex: bottomBarSwitchPosition,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.photo_filter),
                    label: "Filter",
                    tooltip: "Filter Image"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.crop_rotate),
                    label: "Adjust",
                    tooltip: "Crop and Rotate"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_reaction_outlined),
                    label: "Emoji",
                    tooltip: "Add Emoji"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
