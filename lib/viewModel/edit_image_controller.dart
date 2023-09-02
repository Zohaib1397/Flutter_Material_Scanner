import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import '../model/StackList.dart';

class EditImageController{
  //File to be called at initialization stage where we get the file from the uri of the provided document
  late File file;

  EditImageController(){
    undoStack = StackList();
    redoStack = StackList();
  }
  /*--------------
  * Color Filter Section
  * ------------*/
  ///[FilterButton, AdjustButton, AddElementButton]
  List<bool> menuItemToggle = [false, false, false];
  //Filter Toggle is the Color Filter option upon selecting the color filter option in the bottom bar
  int currentFilterIndex =
  0; // to determine which color filter the user is currently in
  final pageController = PageController(); // Color filter page controller

  //These stacks are maintained during the editing process
  late StackList<Uint8List> undoStack;
  late StackList<Uint8List> redoStack;

  bool navBarActive = true;

  ///----------------
  /// Custom Functions
  /// ---------------

  void resetRedoStack(){
    redoStack.clear();
  }

  bool checkForAnyActivatedToggle(){
    for(int i =0 ;i<menuItemToggle.length;i++){
      if(menuItemToggle[i] && i!=1){
        navBarActive = false;
        return true;
      }
    }
    return false;
  }

  void resetToggles(){
    navBarActive = true;
    menuItemToggle = List.filled(menuItemToggle.length, false);
  }

  Image convertUnsignedToImage(Uint8List uInt8list, double width){
    return Image.memory(uInt8list, width: width, filterQuality: FilterQuality.high,);
  }

  Future<Uint8List> convertImageToUnsigned(Image image) async {
    ImageProvider imageProvider = image.image;
    ImageStream imageStream = imageProvider.resolve(ImageConfiguration.empty);
    Completer<Uint8List> completer = Completer();

    // Convert the loaded image to UInt8List
    imageStream.addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) async {
      ByteData? byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List uInt8list = byteData!.buffer.asUint8List();
      completer.complete(uInt8list);
    }));

    Uint8List imageUInt8List = await completer.future;
    return imageUInt8List;
  }

  Future<Uint8List?> convertFilterToImage(GlobalKey colorFilteredImageKey) async {
    //This code is needed to be changed
    RenderRepaintBoundary renderRepaintBoundary =
    colorFilteredImageKey.currentContext?.findRenderObject()
    as RenderRepaintBoundary;
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 4);
    ByteData? byteData =
    await boxImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void toggleMenuItem(int index){
    menuItemToggle = List.generate(menuItemToggle.length, (i)=> i!=index? false: true);
  }
  void dispose(){
    undoStack.clear();
    redoStack.clear();
    currentFilterIndex = 0;
  }
}