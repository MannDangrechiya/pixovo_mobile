import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/template.dart';
import '../services/template_service.dart';

/// Template list state.
class TemplateState {
  final List<Template> templates;
  final List<String> categories;
  final String? selectedCategory;
  final String? searchQuery;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final Template? selectedTemplate;

  const TemplateState({
    this.templates = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery,
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
    this.selectedTemplate,
  });

  TemplateState copyWith({
    List<Template>? templates,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    Template? selectedTemplate,
    bool clearSelectedCategory = false,
    bool clearSearchQuery = false,
  }) {
    return TemplateState(
      templates: templates ?? this.templates,
      categories: categories ?? this.categories,
      selectedCategory:
          clearSelectedCategory ? null : selectedCategory ?? this.selectedCategory,
      searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
    );
  }
}

/// Manages template listing, filtering, and pagination.
class TemplateNotifier extends StateNotifier<TemplateState> {
  final TemplateService _templateService;

  TemplateNotifier(this._templateService) : super(const TemplateState());

  /// Load the first page of templates and available categories.
  Future<void> loadTemplates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await Future.wait([
        _templateService.getTemplates(
          page: 1,
          category: state.selectedCategory,
          search: state.searchQuery,
        ),
        _templateService.getCategories(),
      ]);

      final templates = results[0] as List<Template>;
      final categories = results[1] as List<String>;

      state = state.copyWith(
        templates: templates,
        categories: categories,
        isLoading: false,
        currentPage: 1,
        hasMore: templates.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        templates: state.templates.isEmpty ? _fallbackTemplates : state.templates,
        categories: state.categories.isEmpty ? _fallbackCategories : state.categories,
        isLoading: false,
        errorMessage: e.toString(),
        hasMore: false,
      );
    }
  }

  /// Load the next page (infinite scroll).
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    try {
      final nextPage = state.currentPage + 1;
      final newTemplates = await _templateService.getTemplates(
        page: nextPage,
        category: state.selectedCategory,
        search: state.searchQuery,
      );

      state = state.copyWith(
        templates: [...state.templates, ...newTemplates],
        isLoading: false,
        currentPage: nextPage,
        hasMore: newTemplates.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Filter by category.
  Future<void> setCategory(String? category) async {
    state = state.copyWith(
      selectedCategory: category,
      clearSelectedCategory: category == null,
      currentPage: 1,
    );
    await loadTemplates();
  }

  /// Search templates.
  Future<void> search(String query) async {
    state = state.copyWith(
      searchQuery: query.isEmpty ? null : query,
      clearSearchQuery: query.isEmpty,
    );
    await loadTemplates();
  }

  /// Load a single template detail.
  Future<void> loadTemplateDetail(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final template = await _templateService.getTemplateDetail(id);
      state = state.copyWith(
        selectedTemplate: template,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

const _fallbackCategories = ['Family', 'Travel', 'Baby', 'Wedding'];

const _fallbackTemplates = [
  Template(
    id: 'family-classic',
    name: 'Family Classic',
    description: 'A clean photo book for everyday memories.',
    thumbnailUrl: '',
    category: 'Family',
    pageCount: 24,
    price: 999,
  ),
  Template(
    id: 'travel-story',
    name: 'Travel Story',
    description: 'A bright layout for holidays and adventures.',
    thumbnailUrl: '',
    category: 'Travel',
    pageCount: 32,
    price: 1299,
  ),
  Template(
    id: 'baby-first-year',
    name: 'Baby First Year',
    description: 'A soft album for milestones and tiny details.',
    thumbnailUrl: '',
    category: 'Baby',
    pageCount: 28,
    price: 1199,
  ),
  Template(
    id: 'wedding-keepsake',
    name: 'Wedding Keepsake',
    description: 'A polished book for wedding highlights.',
    thumbnailUrl: '',
    category: 'Wedding',
    pageCount: 40,
    price: 1599,
  ),
];

/// Provider for the TemplateService.
final templateServiceProvider = Provider<TemplateService>((ref) {
  return TemplateService();
});

/// Provider for the TemplateNotifier.
final templateProvider =
    StateNotifierProvider<TemplateNotifier, TemplateState>((ref) {
  return TemplateNotifier(ref.read(templateServiceProvider));
});
