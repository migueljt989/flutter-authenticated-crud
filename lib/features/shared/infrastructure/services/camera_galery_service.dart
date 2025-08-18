

abstract class CameraGaleryService {

  Future<String?> takePhoto ();
  Future<String?> selectPhoto ();
  Future<List<String?>> selectMultiplePhoto ();
}