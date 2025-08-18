import 'package:image_picker/image_picker.dart';

import 'camera_galery_service.dart';

class CameraGaleryServiceImpl extends CameraGaleryService{

  final ImagePicker _picker = ImagePicker();

  @override
  Future<List<String?>> selectMultiplePhoto() {
    // TODO: implement selectMultiplePhoto
    throw UnimplementedError();
  }

  @override
  Future<String?> selectPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      );
    if ( image == null ) return null;

    print('Tenemos una imagen ${image.path}');

    return image.path;

  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
      );

    if ( photo == null ) return null;

    print('Tenemos una imagen ${photo.path}');

    return photo.path;
  }
}