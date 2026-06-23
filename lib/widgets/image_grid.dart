import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/image.dart';

/// Reusable grid layout for displaying images with optional selection support.
class ImageGrid extends StatelessWidget {
  final List<UserImage> images;
  final Set<String> selectedIds;
  final void Function(String imageId)? onImageTap;
  final void Function(String imageId)? onImageLongPress;
  final int crossAxisCount;
  final double spacing;
  final bool showSelection;

  const ImageGrid({
    super.key,
    required this.images,
    this.selectedIds = const {},
    this.onImageTap,
    this.onImageLongPress,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.showSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (images.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No images',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        final isSelected = selectedIds.contains(image.id);

        return GestureDetector(
          onTap: () => onImageTap?.call(image.id),
          onLongPress: () => onImageLongPress?.call(image.id),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: image.thumbnailUrl ?? image.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image, size: 24),
                  ),
                ),
              ),

              // Selection overlay
              if (showSelection && isSelected)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),

              // Selection indicator
              if (showSelection)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.black.withValues(alpha: 0.3),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
