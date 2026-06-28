import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/image_provider.dart';

/// Image editor screen with crop, rotate, and filter controls.
class ImageEditorScreen extends ConsumerStatefulWidget {
  final String imageId;

  const ImageEditorScreen({super.key, required this.imageId});

  @override
  ConsumerState<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends ConsumerState<ImageEditorScreen> {
  double _rotation = 0;
  bool _flipHorizontal = false;
  bool _flipVertical = false;
  double _brightness = 0;
  double _contrast = 0;
  int _selectedFilterIndex = 0;

  final List<_FilterOption> _filters = const [
    _FilterOption(name: 'Original', matrix: null),
    _FilterOption(name: 'Warm', matrix: null),
    _FilterOption(name: 'Cool', matrix: null),
    _FilterOption(name: 'B&W', matrix: null),
    _FilterOption(name: 'Vintage', matrix: null),
    _FilterOption(name: 'Vivid', matrix: null),
  ];

  void _rotateRight() {
    setState(() => _rotation += 90);
  }

  void _rotateLeft() {
    setState(() => _rotation -= 90);
  }

  void _toggleFlipH() {
    setState(() => _flipHorizontal = !_flipHorizontal);
  }

  void _toggleFlipV() {
    setState(() => _flipVertical = !_flipVertical);
  }

  void _resetEdits() {
    setState(() {
      _rotation = 0;
      _flipHorizontal = false;
      _flipVertical = false;
      _brightness = 0;
      _contrast = 0;
      _selectedFilterIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userImageProvider);

    // Find the image by ID.
    final image =
        state.images.where((img) => img.id == widget.imageId).firstOrNull;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Edit Photo'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _resetEdits,
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              // Save edited image
              context.pop();
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFFE94560),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Image preview area
          Expanded(
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_rotation * math.pi / 180)
                  ..multiply(Matrix4.diagonal3Values(
                    _flipHorizontal ? -1.0 : 1.0,
                    _flipVertical ? -1.0 : 1.0,
                    1.0,
                  )),
                child: image != null
                    ? CachedNetworkImage(
                        imageUrl: image.url,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Color(0xFFE94560)),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 64,
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 64,
                      ),
              ),
            ),
          ),

          // Editing controls
          Container(
            color: const Color(0xFF1A1A1A),
            child: Column(
              children: [
                // Transform controls
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _EditorButton(
                        icon: Icons.rotate_left,
                        label: 'Rotate L',
                        onTap: _rotateLeft,
                      ),
                      _EditorButton(
                        icon: Icons.rotate_right,
                        label: 'Rotate R',
                        onTap: _rotateRight,
                      ),
                      _EditorButton(
                        icon: Icons.flip,
                        label: 'Flip H',
                        onTap: _toggleFlipH,
                        isActive: _flipHorizontal,
                      ),
                      _EditorButton(
                        icon: Icons.flip,
                        label: 'Flip V',
                        onTap: _toggleFlipV,
                        isActive: _flipVertical,
                        rotateIcon: true,
                      ),
                      _EditorButton(
                        icon: Icons.crop,
                        label: 'Crop',
                        onTap: () {
                          // Open crop tool
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),

                // Brightness slider
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.brightness_6,
                          color: Colors.white70, size: 20),
                      Expanded(
                        child: Slider(
                          value: _brightness,
                          min: -1,
                          max: 1,
                          activeColor: const Color(0xFFE94560),
                          onChanged: (v) => setState(() => _brightness = v),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${(_brightness * 100).toInt()}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Contrast slider
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.contrast,
                          color: Colors.white70, size: 20),
                      Expanded(
                        child: Slider(
                          value: _contrast,
                          min: -1,
                          max: 1,
                          activeColor: const Color(0xFFE94560),
                          onChanged: (v) => setState(() => _contrast = v),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${(_contrast * 100).toInt()}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12, height: 1),

                // Filter options
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    itemCount: _filters.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilterIndex == index;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilterIndex = index),
                        child: Column(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFFE94560),
                                        width: 2)
                                    : null,
                                color: Colors.grey.shade800,
                              ),
                              child: Icon(
                                Icons.filter,
                                color: isSelected
                                    ? const Color(0xFFE94560)
                                    : Colors.white54,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              filter.name,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFFE94560)
                                    : Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool rotateIcon;

  const _EditorButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.rotateIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Transform.rotate(
            angle: rotateIcon ? math.pi / 2 : 0,
            child: Icon(
              icon,
              color: isActive
                  ? const Color(0xFFE94560)
                  : Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFE94560)
                  : Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  final String name;
  final List<double>? matrix;

  const _FilterOption({required this.name, this.matrix});
}
