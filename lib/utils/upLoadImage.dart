import 'package:image_picker/image_picker.dart';

class UpLoadImage {
  /*拍照*/
  static getImageCameraFile() async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
      );
      print(pickedFile);
      return pickedFile;
    } catch (e) {
      print(e);
    }
  }

  /*相册*/
  static getImageGalleryFile() async {
    try {
      /*拍照*/
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
      print(pickedFile);
      return pickedFile;
    } catch (e) {
      print(e);
    }
  }
}
