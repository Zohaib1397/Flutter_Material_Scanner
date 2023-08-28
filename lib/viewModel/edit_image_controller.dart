import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';

class EditImageController{
  //File to be called at initialization stage where we get the file from the uri of the provided document
  late File file;

  /*--------------
  * Color Filter Section
  * ------------*/
  ///[FilterButton, AdjustButton, AddElementButton]
  List<bool> menuItemToggle = [false, false, false];
  //Filter Toggle is the Color Filter option upon selecting the color filter option in the bottom bar
  int currentFilterIndex =
  0; // to determine which color filter the user is currently in
  final pageController = PageController(); // Color filter page controller

  int? bottomBarSwitchPosition =
  -1; // determine the position of the selected button
  //Image from file which can be changed dynamically by modification features
  Image? currentImage;


  //These stacks are maintained during the editing process
  List<Uint8List> undoStack = [];
  List<Uint8List> redoStack = [];

  ///----------------
  /// Custom Functions
  /// ---------------

  bool checkForAnyActivatedToggle(){
    for(int i =0 ;i<menuItemToggle.length;i++){
      if(menuItemToggle[i]){
        return true;
      }
    }
    return false;
  }

  void resetToggles(){
    menuItemToggle = List.filled(menuItemToggle.length, false);
  }

  Image convertUnsignedToImage(Uint8List uInt8list, double width){
    return Image.memory(uInt8list, width: width,);
  }

  Future<Uint8List> convertImageToUnsigned(File file) async {
    return await file.readAsBytes();
  }

  Future<Uint8List?> convertFilterToImage(GlobalKey colorFilteredImageKey) async {
    RenderRepaintBoundary renderRepaintBoundary =
    colorFilteredImageKey.currentContext?.findRenderObject()
    as RenderRepaintBoundary;
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData? byteData =
    await boxImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void toggleMenuItem(int index){
    menuItemToggle = List.generate(menuItemToggle.length, (i)=> i!=index? false: true);
  }

}