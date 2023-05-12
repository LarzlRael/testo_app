abstract class CameraGalleryService {
  Future<String?> takePhoto();
  Future<String?> selectFromGallery();
  Future<List<String>?> selectMultiplePhotohs();
}
