import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/routes.dart';
import '../../providers/editor_provider.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String templateId;

  const EditorScreen({super.key, required this.templateId});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final Map<String, ValueNotifier<Matrix4>> _itemNotifiers = {};

  ValueNotifier<Matrix4> _getNotifier(String id) {
    if (!_itemNotifiers.containsKey(id)) {
      _itemNotifiers[id] = ValueNotifier(Matrix4.identity());
    }
    return _itemNotifiers[id]!;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final pages = state.pages;
    
    if (pages.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final currentPageIndex = state.currentPageIndex;
    final currentPage = pages[currentPageIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E), // Navy primary
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Editor', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () {
              context.push('${AppRoutes.imageDashboard}?templateId=${widget.templateId}');
            },
          ),
          TextButton(
            onPressed: () {
              context.push('${AppRoutes.bookPreview}?templateId=${widget.templateId}');
            },
            child: const Text('Preview', style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Canvas area
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Items
                        ...currentPage.items.map((item) {
                          final notifier = _getNotifier(item.id);
                          return MatrixGestureDetector(
                            onMatrixUpdate: (m, tm, sm, rm) {
                              notifier.value = m;
                            },
                            child: AnimatedBuilder(
                              animation: notifier,
                              builder: (context, child) {
                                return Transform(
                                  transform: notifier.value,
                                  child: Container(
                                    width: item.width,
                                    height: item.height,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5), width: 1),
                                    ),
                                    child: item.type == 'image'
                                        ? CachedNetworkImage(
                                            imageUrl: item.content ?? '',
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                                          )
                                        : Center(child: Text(item.content ?? '')),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Page thumbnails (Bottom Pane)
          Container(
            height: 100,
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: pages.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final isSelected = index == currentPageIndex;
                return GestureDetector(
                  onTap: () {
                    ref.read(editorProvider.notifier).setCurrentPage(index);
                  },
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFE94560), width: 3)
                          : Border.all(color: Colors.transparent, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        'Page ${index + 1}',
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFE94560) : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
