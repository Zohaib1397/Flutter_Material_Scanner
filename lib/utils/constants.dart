import 'package:material_scanner/model/layout.dart';
import 'package:flutter/material.dart';

Layout activeLayout = Layout.GRID;

const kConstantBlackScreenIconTheme = IconThemeData(
  color: Colors.white,
);

const kConstantBlackScreenLabelTheme = TextStyle(
  color: Colors.white,
);

///---------------------
///Color Filters section
///---------------------

List<List<double>> colorFilters = [
  NORMAL,
  SEPIA_MATRIX,
  SEPIUM,
  SWEET_MATRIX,
  GREYSCALE_MATRIX,
  VINTAGE_MATRIX,
  PURPLE
];

const NORMAL = [1.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const SEPIA_MATRIX = [0.39, 0.769, 0.189, 0.0, 0.0,
  0.349, 0.686, 0.168, 0.0, 0.0,
  0.272, 0.534, 0.131, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const GREYSCALE_MATRIX = [0.2126, 0.7152, 0.0722, 0.0, 0.0,
  0.2126, 0.7152, 0.0722, 0.0, 0.0,
  0.2126, 0.7152, 0.0722, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];


const VINTAGE_MATRIX = [0.9, 0.5, 0.1, 0.0, 0.0,
  0.3, 0.8, 0.1, 0.0, 0.0,
  0.2, 0.3, 0.5, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const SWEET_MATRIX = [1.0, 0.0, 0.2, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];

const PURPLE = [1.0, -0.2, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, -0.1, 0.0,
  0.0, 1.2, 1.0, 0.1, 0.0,
  0.0, 0.0, 1.7, 1.0, 0.0];

const SEPIUM = [1.3, -0.3, 1.1, 0.0, 0.0,
  0.0, 1.3, 0.2, 0.0, 0.0,
  0.0, 0.0, 0.8, 0.2, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0];