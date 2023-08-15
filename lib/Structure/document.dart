import 'picture.dart';

class Document{
  late Picture picture;
  late DateTime timeStamp;
  late Picture croppedPicture;


  Document(this.picture, this.timeStamp, this.croppedPicture);
}