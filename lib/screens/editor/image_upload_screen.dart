import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../providers/image_provider.dart';
import '../../services/image_service.dart';

/// Screen for uploading photos from gallery or camera.
class ImageUploadScreen extends ConsumerStatefulWidget {
  final String templateId;

  const ImageUploadScreen({super.key, required this.templateId});

  @override
  ConsumerState<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends ConsumerState<ImageUploadScreen> {
  final ImageService _imageService = ImageService();
  final List<File> _selectedFiles = [];

  Future<void> _pickFromGallery() async {
    final files = await _imageService.pickMultipleFromGallery();
    if (files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(files.map((xFile) => File(xFile.path)));
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final file = await _imageService.pickFromCamera();
    if (file != null) {
      setState(() {
        _selectedFiles.add(File(file.path));
      });
    }
  }

  Future<void> _uploadAll() async {
    final notifier = ref.read(userImageProvider.notifier);
    for (final file in _selectedFiles) {
      await notifier.uploadImage(file);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Images uploaded successfully!')),
    );

    context.push(
      '${AppRoutes.imageDashboard}?templateId=${widget.templateId}',
    );
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageState = ref.watch(userImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Upload options
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _UploadOptionCard(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    description: 'Choose from photos',
                    onTap: _pickFromGallery,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _UploadOptionCard(
                    icon: Icons.camera_alt_outlined,
                    label: 'Camera',
                    description: 'Take a photo',
                    onTap: _pickFromCamera,
                  ),
                ),
              ],
            ),
          ),

          // Upload progress indicator
          if (imageState.isUploading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: imageState.uploadProgress,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uploading... ${(imageState.uploadProgress * 100).toInt()}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

          // Selected files preview
          Expanded(
            child: _selectedFiles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 80,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No photos selected yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap Gallery or Camera to add photos',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _selectedFiles.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedFiles[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeFile(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomSheet: _selectedFiles.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: imageState.isUploading ? null : _uploadAll,
                    child: Text(
                      'Upload ${_selectedFiles.length} Photo${_selectedFiles.length > 1 ? 's' : ''}',
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

/// Individual upload option card (Gallery / Camera).
class _UploadOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _UploadOptionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
