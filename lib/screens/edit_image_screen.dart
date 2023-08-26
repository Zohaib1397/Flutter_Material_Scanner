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
  int borderAtIndex = 0;
  final controller = PageController();
  List<List<double>> colorFilters = [NORMAL, SEPIA_MATRIX, SEPIUM, SWEET_MATRIX, GREYSCALE_MATRIX, VINTAGE_MATRIX, PURPLE];

  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.from(colorScheme: ScannerTheme().darkColorScheme),
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
                child: filterToggle
                    ? PageView.builder(
                        controller: controller,
                        itemCount: colorFilters.length,
                        itemBuilder: (context, index) => ColorFiltered(
                          colorFilter: ColorFilter.matrix(colorFilters[index]),
                          child: Image.file(
                                file,
                                width: screenSize.width,
                              ),
                        ))
                    : PhotoView.customChild(
                        child: Image.file(
                          file,
                          width: screenSize.width,
                        ),
                      ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: filterToggle ? 80 : 0,
              child: Container(
                color: Colors.black,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colorFilters.length,
                    itemBuilder: (context, index) {
                      return index == borderAtIndex
                          ? Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: buildImageFromFile(index),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                  borderAtIndex = index;
                                });
                              },
                              child: buildImageFromFile(index),
                            );
                    }),
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
                } else if (value == 1) {
                  setState(() {
                    filterToggle = false;
                    bottomBarSwitchPosition = 1;
                  });
                } else if (value == 2) {
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

  Widget buildImageFromFile(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(colorFilters[index]),
        child: Image.file(
          file,
          width: 60.0,
          height: 60.0,
        ),
      ),
    );
  }
}
