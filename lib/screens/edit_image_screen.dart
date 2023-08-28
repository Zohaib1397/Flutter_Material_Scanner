import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_scanner/Theme/scanner_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import '../model/document.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../utils/constants.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key});

  // final Document document;

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
  bool filterToggle = false;
  int currentFilterIndex =
      0; // to determine which color filter the user is currently in
  final controller = PageController(); // Color filter page controller

  ///-----------------
  ///Adjust (Crop and rotate) section
  ///-----------------
  bool adjustToggle = false;

  ///-----------------
  ///add (Emoji) section
  ///-----------------
  bool addElementToggle = false;

  int? bottomBarSwitchPosition =
      -1; // determine the position of the selected button
  //Image from file which can be changed dynamically by modification features
  Image? currentImage;

  // Size widget for current device width and height
  late Size screenSize;

  //These stacks are maintained during the editing process
  List<Uint8List> undoStack = [];
  List<Uint8List> redoStack = [];

  ///----------------
  /// Custom Functions
  /// ---------------
  Size getScreenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  Future<Uint8List> convertImageToUnsigned(File file) async {
    return await file.readAsBytes();
  }

  void convertFilterToImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        _colorFilteredImageKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary;
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData? byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
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
    // file = File(widget.document.uri);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = getScreenSize(context);
    currentImage ??= Image(image: const AssetImage("assets/stable-diffusion-xl-5.jpg"), width: screenSize.width);
    // currentImage ??= Image.file(file, width: screenSize.width);
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
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        convertFilterToImage();
                      });
                    },
                    icon: const Icon(Icons.done))
                : IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
          ],
        ),
        body: SafeArea(
          child: Column(
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
                height: filterToggle ? 56 : 0,
                child: Container(
                  color: Colors.black,
                  child: ListView.separated(
                    separatorBuilder: (context, index){
                      return const SizedBox(width: 5,);
                    },
                      scrollDirection: Axis.horizontal,
                      itemCount: colorFilters.length,
                      itemBuilder: (context, index) {
                        return index == currentFilterIndex
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.red),
                                    bottom: BorderSide(color: Colors.red),
                                    left: BorderSide(color: Colors.red),
                                    right: BorderSide(color: Colors.red),
                                  ),
                                  // color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(46),
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
              const SizedBox(height: 10,),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                constraints: BoxConstraints(
                  minWidth: screenSize.width,
                  maxHeight: 56,
                ),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildBottomToolsButton(
                      Icons.photo_filter_rounded,
                      "Filter",
                      onPressed: () {
                        setState(() {
                          filterToggle = !filterToggle;
                        });
                      },
                      active: filterToggle,
                    ),
                    buildBottomToolsButton(
                      Icons.crop_rotate_rounded,
                      "Adjust",
                      onPressed: () {
                        setState(() {
                          adjustToggle = !adjustToggle;
                        });
                      },
                      active: adjustToggle,
                    ),
                    buildBottomToolsButton(
                      Icons.add_reaction_outlined,
                      "Emoji",
                      onPressed: () {
                        setState(() {
                          addElementToggle = !addElementToggle;
                        });
                      },
                      active: addElementToggle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomToolsButton(IconData iconData, String title,
      {bool active = false, required Function() onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: active
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
            ),
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                  vertical: 3.0, horizontal: active ? 10.0 : 0.0),
              child: Icon(iconData,
                  color: active
                      ? Colors.black
                      : Theme.of(context).colorScheme.onPrimary),
            ),
          ),
          Text(title)
        ],
      ),
    );
  }

  Widget buildImageFromFile(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(46),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(colorFilters[index]),
        child: const Image(
          image: AssetImage("assets/stable-diffusion-xl-5.jpg"),
          // height: 60,
          // width: 60,
        ),
        // child: Image.file(
        //   file,
        //   width: 60.0,
        //   height: 60.0,
        // ),
      ),
    );
  }
}
