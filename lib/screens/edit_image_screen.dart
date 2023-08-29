import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_scanner/Theme/scanner_theme.dart';
import 'package:photo_view/photo_view.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../viewModel/edit_image_controller.dart';
import 'dart:io';

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

  PageController pageController =
      PageController(); // Color filter page controller

  //Image from file which can be changed dynamically by modification features
  Image? currentImage;

  // Size widget for current device width and height
  late Size screenSize;

  bool initialFilterRun = false;

  ///----------------
  /// Custom Functions
  /// ---------------

  Size getScreenSize(BuildContext context) {
    return MediaQuery.sizeOf(context);
  }

  Image? defaultImage;
  final ImagePicker picker = ImagePicker();
  XFile? image;

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
          centerTitle: false,
          elevation: 0,
          title: const Text("Edit Image"),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: imageController.checkForAnyActivatedToggle()
              ? IconButton(
                  onPressed: () => setState(
                    () {
                      if (imageController.currentFilterIndex != 0) {
                        Utils.showAlertDialog(
                          context,
                          "Discard Changes",
                          "Are you sure to discard the changes?",
                          "Yes",
                          cancelText: "No",
                          () => () {
                            imageController.resetToggles();
                          },
                        );
                      }else{
                        imageController.resetToggles();
                      }
                    },
                  ),
                  icon: const Icon(Icons.close),
                )
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
          actions: [
            //If undo stack is null the undo button is disabled
            IconButton(
              disabledColor: Colors.white10,
              onPressed: imageController.undoStack.isEmpty ? null : () {},
              icon: const Icon(Icons.undo_rounded),
            ),
            //similarly if redo stack is empty the redo button is disabled
            IconButton(
              disabledColor: Colors.white10,
              onPressed: imageController.redoStack.isEmpty ? null : () {},
              icon: const Icon(Icons.redo_rounded),
            ),
            //Checking if any of the Menu button is toggled
            imageController.checkForAnyActivatedToggle()
                //If toggled then show Tick button and perform save action of current activity
                ? IconButton(
                    onPressed: () async {
                      defaultImage = currentImage;
                      Uint8List? uInt8list = await imageController
                          .convertFilterToImage(_colorFilteredImageKey);
                      setState(() {
                        if (uInt8list != null) {
                          currentImage = imageController.convertUnsignedToImage(
                              uInt8list, screenSize.width);
                          imageController.resetToggles();
                        }
                        initialFilterRun = true;
                      });
                    },
                    icon: const Icon(Icons.done))
                //if not then show save button that handles the database activity of saving
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
                              controller: pageController,
                              //Page controller manipulated by filter row
                              itemCount: colorFilters.length,
                              onPageChanged: (value) {
                                setState(() {
                                  imageController.currentFilterIndex = value;
                                });
                              },
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
                if (initialFilterRun) currentImage = defaultImage;
                pageController = PageController(
                    initialPage: imageController.currentFilterIndex);
                imageController.toggleMenuItem(0);
              });
            },
            active: imageController.menuItemToggle[0],
          ),
          buildBottomToolsButton(
            Icons.crop_rotate_rounded,
            "Adjust",
            onPressed: () async {
              setState(() {
                imageController.toggleMenuItem(1);
              });
              image = await picker.pickImage(source: ImageSource.gallery);
              CroppedFile? croppedFile = await ImageCropper().cropImage(
                sourcePath: image!.path,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
                uiSettings: [
                  AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      toolbarWidgetColor: Colors.black,
                      initAspectRatio: CropAspectRatioPreset.original,
                      lockAspectRatio: false),
                  IOSUiSettings(
                    title: 'Cropper',
                  ),
                ],
              );
              currentImage = Image.file(File(croppedFile!.path));
              // await ImageCropper.cropImage(sourcePath: image!.path);
            },
            active: imageController.menuItemToggle[1],
          ),
          buildBottomToolsButton(
            Icons.add_reaction_outlined,
            "Emoji",
            onPressed: () async {
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
                          pageController.animateToPage(index,
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
          const SizedBox(height: 2),
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
