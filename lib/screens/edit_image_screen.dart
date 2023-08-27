import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_scanner/Theme/scanner_theme.dart';
import 'package:photo_view/photo_view.dart';
import '../model/document.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../utils/constants.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key, required this.document});

  final Document document;

  static const String id = "EditImageScreen";

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {

  //File to be called at initialization stage where we get the file from the uri of the provided document
  late File file;


  /*--------------
  * Color Filter Section
  * ------------*/
  final GlobalKey _colorFilteredImageKey = GlobalKey();
  //Filter Toggle is the Color Filter option upon selecting the color filter option in the bottom bar
  bool filterToggle = true;
  int currentFilterIndex = 0; // to determine which color filter the user is currently in
  final controller = PageController(); // Color filter page controller

  int bottomBarSwitchPosition = 0; // determine the position of the selected button
  //Image from file which can be changed dynamically by modification features
  Image? currentImage;

  // Size widget for current device width and height
  late Size screenSize;

  ///----------------
  /// Custom Functions
  /// ---------------
  Size getScreenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  void convertFilterToImage()async{
    RenderRepaintBoundary renderRepaintBoundary = _colorFilteredImageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? uInt8list = byteData?.buffer.asUint8List();
    setState(() {
      currentImage = Image.memory(uInt8list!, width: screenSize.width);
      filterToggle = false;
      bottomBarSwitchPosition = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    file = File(widget.document.uri);
  }


  @override
  Widget build(BuildContext context) {
    screenSize = getScreenSize(context);
    currentImage ??= Image.file(file, width: screenSize.width);
    return Theme(
      data: ThemeData.from(colorScheme: ScannerTheme().darkColorScheme),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Edit Image"),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            filterToggle
                ? IconButton(onPressed: () {
                  setState(() {
                    convertFilterToImage();
                    // currentImage = ColorFiltered(colorFilter: colorFilters[currentFilterIndex], child: currentImage,)
                  });
            }, icon: const Icon(Icons.done))
                : IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: filterToggle
                    ? RepaintBoundary(
                      key: _colorFilteredImageKey,
                      child: PageView.builder(
                          controller: controller,
                          //Page controller manipulated by filter row
                          itemCount: colorFilters.length,
                          itemBuilder: (context, index) => ColorFiltered(
                                colorFilter:
                                    ColorFilter.matrix(colorFilters[index]),
                                child: currentImage,
                              )),
                    )
                    : PhotoView.customChild(
                        child: currentImage,
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
                      return index == currentFilterIndex
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
                                  controller.animateToPage(index,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                  currentFilterIndex = index;
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
