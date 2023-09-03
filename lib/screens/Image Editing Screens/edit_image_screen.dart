import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_scanner/Theme/scanner_theme.dart';
import 'package:photo_view/photo_view.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../model/document.dart';
import '../../viewModel/edit_image_controller.dart';
import 'dart:io';

class EditImageScreen extends StatefulWidget {
  final Document document;
  const EditImageScreen({super.key, required this.document});


  static const String id = "EditImageScreen";

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  final editImageController = EditImageController();

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
    editImageController.file = File(widget.document.uri);
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
          leading: editImageController.checkForAnyActivatedToggle()
              ? IconButton(
                  onPressed: () => setState(
                    () {
                      if (editImageController.currentFilterIndex != 0) {
                        Utils.showAlertDialog(
                          context,
                          title: "Discard Changes",
                          content: "Are you sure to discard the changes?",
                          confirmText: "Discard",
                          onConfirm: () {
                            editImageController.resetToggles();
                          },
                        );
                      } else {
                        editImageController.resetToggles();
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
            editImageController.checkForAnyActivatedToggle()
                ? Container()
                : IconButton(
                    disabledColor: Colors.white10,
                    tooltip: "Undo",

                    ///If this is the case that the undoStack has data then do something on press
                    ///else make the button disable
                    onPressed: editImageController.undoStack.canPop()
                        ? () async {
                            Uint8List previousImage = await editImageController
                                .convertImageToUnsigned(currentImage!);
                            setState(() {
                              ///Take out the last element in the undo stack
                              Uint8List lastElement =
                                  editImageController.undoStack.top();
                              print(lastElement);

                              ///and load it to the image in the center
                              currentImage =
                                  editImageController.convertUnsignedToImage(
                                      lastElement, screenSize.width);

                              ///Also save the last element to the redo stack to make it redo-able
                              editImageController.redoStack.push(previousImage);

                              ///finally pop undo stack element
                              editImageController.undoStack.pop();
                            });
                          }
                        : null,
                    icon: const Icon(Icons.undo_rounded),
                  ),
            //similarly if redo stack is empty the redo button is disabled
            editImageController.checkForAnyActivatedToggle()
                ? Container()
                : IconButton(
                    disabledColor: Colors.white10,
                    tooltip: "Redo",

                    ///If this is the case that the redoStack has data then do something on press
                    ///else make the button disable
                    onPressed: editImageController.redoStack.canPop()
                        ? () async {
                            Uint8List previousImage = await editImageController
                                .convertImageToUnsigned(currentImage!);
                            setState(() {
                              ///Take out the last element in the redo stack
                              ///and load it to the image in the center
                              Uint8List lastElement =
                                  editImageController.redoStack.top();
                              print(lastElement);
                              currentImage =
                                  editImageController.convertUnsignedToImage(
                                      lastElement, screenSize.width);

                              ///Also save the last element to the undo stack to make it undo-able
                              editImageController.undoStack.push(previousImage);

                              ///finally pop redo stack element
                              editImageController.redoStack.pop();
                            });
                          }
                        : null,
                    icon: const Icon(Icons.redo_rounded),
                  ),
            //Checking if any of the Menu button is toggled
            editImageController.checkForAnyActivatedToggle()
                //If toggled then show Tick button and perform save action of current activity
                ? IconButton(
                    onPressed: () async {
                      defaultImage = currentImage;
                      Uint8List? uInt8list = await editImageController
                          .convertFilterToImage(_colorFilteredImageKey);
                      final previousImage = await editImageController
                          .convertImageToUnsigned(currentImage!);
                      setState(() {
                        if (uInt8list != null) {
                          editImageController.undoStack.push(previousImage);
                          currentImage = editImageController.convertUnsignedToImage(
                              uInt8list, screenSize.width);
                          editImageController.resetToggles();
                        }
                        initialFilterRun = true;
                        editImageController.redoStack.clear();
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
                  child: editImageController.menuItemToggle[0]
                      ? RepaintBoundary(
                          key: _colorFilteredImageKey,
                          child: PageView.builder(
                              controller: pageController,
                              //Page controller manipulated by filter row
                              itemCount: colorFilters.length,
                              onPageChanged: (value) {
                                setState(() {
                                  editImageController.currentFilterIndex = value;
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
              editImageController.navBarActive? buildAnimatedBottomNavBar() : Container(),
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
                    initialPage: editImageController.currentFilterIndex);
                editImageController.toggleMenuItem(0);
              });
            },
            active: editImageController.menuItemToggle[0],
          ),
          buildBottomToolsButton(
            Icons.crop_rotate_rounded,
            "Adjust",
            onPressed: () async {
              setState(() {
                editImageController.toggleMenuItem(1);
              });
              image = await picker.pickImage(source: ImageSource.gallery);
              CroppedFile? croppedFile = await ImageCropper().cropImage(
                sourcePath: editImageController.file.path,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
                uiSettings: [
                  AndroidUiSettings(
                    toolbarTitle: 'Crop and Rotate',
                    toolbarColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false,
                    activeControlsWidgetColor:
                        Theme.of(context).colorScheme.primary,
                    dimmedLayerColor: Theme.of(context).disabledColor,
                  ),
                  IOSUiSettings(
                    title: 'Crop and Rotate',
                  ),
                ],
              );
              setState(() => currentImage = croppedFile != null
                  ? Image.file(File(croppedFile.path))
                  : currentImage);
            },
            active: false,
          ),
          // buildBottomToolsButton(
          //   Icons.add_reaction_outlined,
          //   "Emoji",
          //   onPressed: () async {
          //     Uint8List imageMemory = await imageController.convertImageToUnsigned(currentImage!);
          //     showModalBottomSheet(context: context, builder: (context) {
          //
          //       return ImageTextScreen(imageMemory: imageMemory);
          //     });
          //     setState(() {
          //       imageController.toggleMenuItem(2);
          //     });
          //   },
          //   active: imageController.menuItemToggle[2],
          // ),
        ],
      ),
    );
  }

  Widget buildAnimatedFilters() {
    return Container(
      height: editImageController.menuItemToggle[0] ? 56 : 0,
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
            return index == editImageController.currentFilterIndex
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
                        editImageController.currentFilterIndex = index;
                      });
                    },
                    child: buildImageFromFile(index),
                  );
          },
        ),
      ),
    );
  }

  Widget buildBottomToolsButton(IconData iconData, String title,
      {bool active = false, required Function() onPressed}) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(iconData,
              color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(height: 4),
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
        // child: const Image(
        //   image: AssetImage("assets/stable-diffusion-xl-5.jpg"),
        // ),
        child: Image.file(
          editImageController.file,
          width: 60.0,
          height: 60.0,
        ),
      ),
    );
  }
}
