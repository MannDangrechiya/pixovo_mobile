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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text('Your Photos', style: TextStyle(fontWeight: FontWeight.w600)),
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
                style: const TextStyle(
                  color: Color(0xFFE94560),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: state.isLoading && state.images.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE94560)))
          : state.images.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No photos uploaded yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: const Color(0xFF1A1A2E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94560),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => context.push(
                          '${AppRoutes.imageUpload}?templateId=${widget.templateId}',
                        ),
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text(
                          'Upload Photos',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: state.images.length,
                  itemBuilder: (context, index) {
                    final image = state.images[index];
                    final isSelected = state.selectedImageIds.contains(image.id);

                    return GestureDetector(
                      onTap: () {
                        ref.read(userImageProvider.notifier).toggleSelection(image.id);
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
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFE94560),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image, color: Colors.grey),
                              ),
                            ),
                          ),
                          // Selection overlay
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFE94560).withValues(alpha: 0.2),
                                border: Border.all(
                                  color: const Color(0xFFE94560),
                                  width: 3,
                                ),
                              ),
                            ),
                          // Selection checkmark
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xFFE94560)
                                    : Colors.black.withValues(alpha: 0.3),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
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
      bottomNavigationBar: state.selectedImageIds.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${state.selectedImageIds.length} photo${state.selectedImageIds.length > 1 ? 's' : ''}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94560),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            context.push(
                              '${AppRoutes.bookPreview}?templateId=${widget.templateId}',
                            );
                          },
                          child: const Text(
                            'Add to Project',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE94560),
        foregroundColor: Colors.white,
        onPressed: () => context.push(
          '${AppRoutes.imageUpload}?templateId=${widget.templateId}',
        ),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }
}
