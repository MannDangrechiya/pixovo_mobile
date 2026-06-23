import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/image.dart';
import '../services/image_service.dart';

/// Image upload & management state.
class UserImageState {
  final List<UserImage> images;
  final Set<String> selectedImageIds;
  final bool isLoading;
  final bool isUploading;
  final double uploadProgress;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const UserImageState({
    this.images = const [],
    this.selectedImageIds = const {},
    this.isLoading = false,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  UserImageState copyWith({
    List<UserImage>? images,
    Set<String>? selectedImageIds,
    bool? isLoading,
    bool? isUploading,
    double? uploadProgress,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return UserImageState(
      images: images ?? this.images,
      selectedImageIds: selectedImageIds ?? this.selectedImageIds,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Manages user images — upload, list, select, delete.
class UserImageNotifier extends StateNotifier<UserImageState> {
  final ImageService _imageService;

  UserImageNotifier(this._imageService) : super(const UserImageState());

  /// Load user images (first page).
  Future<void> loadImages() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final images = await _imageService.getUserImages(page: 1);
      state = state.copyWith(
        images: images,
        isLoading: false,
        currentPage: 1,
        hasMore: images.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Load next page of images.
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final nextPage = state.currentPage + 1;
      final newImages =
          await _imageService.getUserImages(page: nextPage);

      state = state.copyWith(
        images: [...state.images, ...newImages],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newImages.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Upload a single image file.
  Future<void> uploadImage(File file) async {
    state = state.copyWith(isUploading: true, uploadProgress: 0, errorMessage: null);
    try {
      final uploaded = await _imageService.uploadImage(
        file,
        onProgress: (progress) {
          state = state.copyWith(uploadProgress: progress);
        },
      );
      state = state.copyWith(
        images: [uploaded, ...state.images],
        isUploading: false,
        uploadProgress: 1.0,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Delete an image.
  Future<void> deleteImage(String imageId) async {
    try {
      await _imageService.deleteImage(imageId);
      state = state.copyWith(
        images: state.images.where((img) => img.id != imageId).toList(),
        selectedImageIds: state.selectedImageIds.difference({imageId}),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Toggle image selection.
  void toggleSelection(String imageId) {
    final selected = Set<String>.from(state.selectedImageIds);
    if (selected.contains(imageId)) {
      selected.remove(imageId);
    } else {
      selected.add(imageId);
    }
    state = state.copyWith(selectedImageIds: selected);
  }

  /// Select all images.
  void selectAll() {
    state = state.copyWith(
      selectedImageIds: state.images.map((img) => img.id).toSet(),
    );
  }

  /// Clear all selections.
  void clearSelection() {
    state = state.copyWith(selectedImageIds: {});
  }
}

/// Provider for the ImageService.
final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

/// Provider for the UserImageNotifier.
final userImageProvider =
    StateNotifierProvider<UserImageNotifier, UserImageState>((ref) {
  return UserImageNotifier(ref.read(imageServiceProvider));
});
