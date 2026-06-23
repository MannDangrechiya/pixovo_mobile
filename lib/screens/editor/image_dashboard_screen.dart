import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/routes.dart';
import '../../providers/image_provider.dart';

/// Dashboard showing all uploaded images with selection support.
class ImageDashboardScreen extends ConsumerStatefulWidget {
  final String templateId;

  const ImageDashboardScreen({super.key, required this.templateId});

  @override
  ConsumerState<ImageDashboardScreen> createState() =>
      _ImageDashboardScreenState();
}

class _ImageDashboardScreenState extends ConsumerState<ImageDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userImageProvider.notifier).loadImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(userImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Photos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (state.images.isNotEmpty)
            TextButton(
              onPressed: () {
                if (state.selectedImageIds.length == state.images.length) {
                  ref.read(userImageProvider.notifier).clearSelection();
                } else {
                  ref.read(userImageProvider.notifier).selectAll();
                }
              },
              child: Text(
                state.selectedImageIds.length == state.images.length
                    ? 'Deselect All'
                    : 'Select All',
              ),
            ),
        ],
      ),
      body: state.isLoading && state.images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.images.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 64,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No photos uploaded yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.push(
                          '${AppRoutes.imageUpload}?templateId=${widget.templateId}',
                        ),
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('Upload Photos'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: state.images.length,
                  itemBuilder: (context, index) {
                    final image = state.images[index];
                    final isSelected =
                        state.selectedImageIds.contains(image.id);

                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(userImageProvider.notifier)
                            .toggleSelection(image.id);
                      },
                      onLongPress: () {
                        context.push(
                          '${AppRoutes.imageEditor}?imageId=${image.id}',
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: image.thumbnailUrl ?? image.url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: theme.colorScheme.surfaceContainerHighest,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          // Selection overlay
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                border: Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                          // Selection checkmark
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
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomSheet: state.selectedImageIds.isNotEmpty
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
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${state.selectedImageIds.length} photo${state.selectedImageIds.length > 1 ? 's' : ''} selected',
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.push(
                          '${AppRoutes.bookPreview}?templateId=${widget.templateId}',
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          '${AppRoutes.imageUpload}?templateId=${widget.templateId}',
        ),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }
}
