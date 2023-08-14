import 'package:flutter/material.dart';
import '/Theme/ScannerTheme.dart';
import 'package:material_scanner/screens/home_screen.dart';

void main(){
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialScannerTheme = ScannerTheme();
    return MaterialApp(
      title: "Material Scanner",
      theme: materialScannerTheme.lightTheme(),
      darkTheme: materialScannerTheme.darkTheme(),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) => const HomeScreen(),
      },
    );
  }
}
