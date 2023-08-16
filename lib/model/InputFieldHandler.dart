import 'package:flutter/material.dart';

class InputFieldHandler {
  late TextEditingController controller;
  late String errorText;

  InputFieldHandler(){
    errorText = "";
    controller = TextEditingController();
  }
}