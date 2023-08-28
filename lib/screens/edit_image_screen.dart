import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_scanner/Theme/scanner_theme.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import '../utils/constants.dart';
import '../viewModel/edit_image_controller.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({super.key});

  // final Document document;

  static const String id = "EditImageScreen";

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {

  final imageController = EditImageController();

  /*--------------
  * Color Filter Section
  * ------------*/
  final GlobalKey _colorFilteredImageKey = GlobalKey();


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

  @override
  void initState() {
    super.initState();
    // imageController.file = File(widget.document.uri);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = getScreenSize(context);
    currentImage ??= Image(
        image: const AssetImage("assets/stable-diffusion-xl-5.jpg"),
        width: screenSize.width);
    // currentImage ??= Image.file(file, width: screenSize.width);
    return Theme(
      data: ThemeData.from(colorScheme: ScannerTheme().darkColorScheme),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          title: const Text("Edit Image"),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: imageController.checkForAnyActivatedToggle()
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      imageController.resetToggles();
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
          actions: [
            imageController.checkForAnyActivatedToggle()
                ? IconButton(
                    onPressed: () async {
                      Uint8List? uInt8list = await imageController.convertFilterToImage(_colorFilteredImageKey);
                      setState(() {
                        if(uInt8list!= null){
                          currentImage = imageController.convertUnsignedToImage(uInt8list, screenSize.width);
                          imageController.resetToggles();
                        }
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
                  child: imageController.menuItemToggle[0]
                      ? RepaintBoundary(
                          key: _colorFilteredImageKey,
                          child: PageView.builder(
                              controller: imageController.pageController,
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
              buildAnimatedFilters(),
              const SizedBox(
                height: 10,
              ),
              buildAnimatedBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedBottomNavBar() {
    return Container(
      constraints: BoxConstraints(
        minWidth: screenSize.width,
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
                imageController.toggleMenuItem(0);
              });
            },
            active: imageController.menuItemToggle[0],
          ),
          buildBottomToolsButton(
            Icons.crop_rotate_rounded,
            "Adjust",
            onPressed: () {
              setState(() {
                imageController.toggleMenuItem(1);
              });
            },
            active: imageController.menuItemToggle[1],
          ),
          buildBottomToolsButton(
            Icons.add_reaction_outlined,
            "Emoji",
            onPressed: () {
              setState(() {
                imageController.toggleMenuItem(2);
              });
            },
            active: imageController.menuItemToggle[2],
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildAnimatedFilters() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: imageController.menuItemToggle[0] ? 56 : 0,
      child: Container(
        color: Colors.black,
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 5,
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: colorFilters.length,
            itemBuilder: (context, index) {
              return index == imageController.currentFilterIndex
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                        // color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(46),
                      ),
                      child: buildImageFromFile(index),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          imageController.pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          imageController.currentFilterIndex = index;
                        });
                      },
                      child: buildImageFromFile(index),
                    );
            }),
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
