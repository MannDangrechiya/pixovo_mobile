import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../models/image.dart';
import 'api_service.dart';

/// Handles image upload, retrieval, and deletion.
class ImageService {
  final ApiService _api = ApiService();
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the device gallery.
  Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2048,
      maxHeight: 2048,
    );
  }

  /// Pick an image from the device camera.
  Future<XFile?> pickFromCamera() async {
    return _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 2048,
      maxHeight: 2048,
    );
  }

  /// Pick multiple images from the gallery.
  Future<List<XFile>> pickMultipleFromGallery() async {
    return _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 2048,
      maxHeight: 2048,
    );
  }

  /// Upload a single image file to the server.
  ///
  /// [onProgress] provides upload progress as a value from 0.0 to 1.0.
  Future<UserImage> uploadImage(
    File file, {
    void Function(double progress)? onProgress,
  }) async {
    final fileName = file.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _api.post(
      ApiConfig.uploadImage,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    return UserImage.fromJson(response.data as Map<String, dynamic>);
  }

  /// Fetch all images uploaded by the current user.
  Future<List<UserImage>> getUserImages({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _api.get(
      ApiConfig.userImages,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final list = response.data['images'] as List<dynamic>;
    return list
        .map((e) => UserImage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Delete an uploaded image by its ID.
  Future<void> deleteImage(String imageId) async {
    await _api.delete('${ApiConfig.deleteImage}/$imageId');
  }
}
