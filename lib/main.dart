import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_scanner/screens/edit_image_screen.dart';
import '/Theme/scanner_theme.dart';
import 'package:material_scanner/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'viewModel/image_view_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ImageViewModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Material Scanner",
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green, applyElevationOverlayColor: true),
      darkTheme: ThemeData(useMaterial3: true),

      // theme: materialScannerTheme.lightTheme(),
      // darkTheme: materialScannerTheme.darkTheme(),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}
