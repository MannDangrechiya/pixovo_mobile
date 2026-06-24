import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../providers/template_provider.dart';

class TemplateDetailScreen extends ConsumerStatefulWidget {
  final String templateId;

  const TemplateDetailScreen({super.key, required this.templateId});

  @override
  ConsumerState<TemplateDetailScreen> createState() => _TemplateDetailScreenState();
}

class _TemplateDetailScreenState extends ConsumerState<TemplateDetailScreen> {
  String? _selectedSize;
  String? _selectedCover;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(templateProvider.notifier).loadTemplateDetail(widget.templateId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(templateProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Template Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final template = state.selectedTemplate;
    if (template == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Template Details')),
        body: Center(
          child: Text(
            state.errorMessage ?? 'Failed to load template',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    final sizes = template.availableSizes?.isNotEmpty == true
        ? template.availableSizes!
        : ['8x8', '10x10', '12x12'];
        
    final covers = template.availableCovers?.isNotEmpty == true
        ? template.availableCovers!
        : ['Softcover', 'Hardcover'];

    _selectedSize ??= sizes.first;
    _selectedCover ??= covers.first;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: template.thumbnailUrl.isNotEmpty
                  ? Image.network(template.thumbnailUrl, fit: BoxFit.cover)
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: Icon(Icons.photo_album, size: 64, color: Colors.grey),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${template.currency} ${template.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    template.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Size Selection
                  Text(
                    'Select Size',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return ChoiceChip(
                        label: Text(size),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedSize = size);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Cover Selection
                  Text(
                    'Select Cover Type',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: covers.map((cover) {
                      final isSelected = _selectedCover == cover;
                      return ChoiceChip(
                        label: Text(cover),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCover = cover);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  
                  // Preview Images (if any)
                  if (template.previewImages.isNotEmpty) ...[
                    Text(
                      'Preview',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: template.previewImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final url = template.previewImages[index];
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${template.currency} ${template.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to image upload and pass template + config if needed
                      context.push('${AppRoutes.imageUpload}?templateId=${template.id}&size=$_selectedSize&cover=$_selectedCover');
                    },
                    child: const Text('Continue to Upload'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
