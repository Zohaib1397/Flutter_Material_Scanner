import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SaveImagePath{
  static Future<String> saveImageFromPath(String imagePath) async{
    try{
      //Get application path using path_provider plugin
      final appPath = await getApplicationDocumentsDirectory();

      //Join the path of application with private_images
      final privateDirectory = Directory(join(appPath.path, 'private_images'));

      //Check if the private_images directory exists or not
      if(!privateDirectory.existsSync()){
        //if not then create the directory
        privateDirectory.createSync();
      }

      final imageName = basename(imagePath);
      final imageFile = File(imagePath);
      final destinationFile = File(join(privateDirectory.path, imageName));
      await imageFile.copy(destinationFile.path);

      return destinationFile.path;
    }catch(e){
      print("Something went wrong: ${e.toString()}");
      return "";
    }
  }
}