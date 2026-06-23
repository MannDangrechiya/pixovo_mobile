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

  const TemplateState({
    this.templates = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery,
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
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
  }) {
    return TemplateState(
      templates: templates ?? this.templates,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
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
        isLoading: false,
        errorMessage: e.toString(),
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
    state = state.copyWith(selectedCategory: category, currentPage: 1);
    await loadTemplates();
  }

  /// Search templates.
  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query.isEmpty ? null : query);
    await loadTemplates();
  }
}

/// Provider for the TemplateService.
final templateServiceProvider = Provider<TemplateService>((ref) {
  return TemplateService();
});

/// Provider for the TemplateNotifier.
final templateProvider =
    StateNotifierProvider<TemplateNotifier, TemplateState>((ref) {
  return TemplateNotifier(ref.read(templateServiceProvider));
});
