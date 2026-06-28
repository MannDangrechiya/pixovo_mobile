import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/page_model.dart';
import '../models/canvas_item.dart';

class EditorState {
  final List<PageModel> pages;
  final int currentPageIndex;

  EditorState({
    this.pages = const [],
    this.currentPageIndex = 0,
  });

  EditorState copyWith({
    List<PageModel>? pages,
    int? currentPageIndex,
  }) {
    return EditorState(
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

class EditorNotifier extends StateNotifier<EditorState> {
  EditorNotifier() : super(EditorState()) {
    _initDefaultPages();
  }

  void _initDefaultPages() {
    state = state.copyWith(
      pages: [
        const PageModel(pageNumber: 1),
        const PageModel(pageNumber: 2),
        const PageModel(pageNumber: 3),
      ],
    );
  }

  void setCurrentPage(int index) {
    if (index >= 0 && index < state.pages.length) {
      state = state.copyWith(currentPageIndex: index);
    }
  }

  void addImageToCurrentPage(String imageUrl) {
    final currentPage = state.pages[state.currentPageIndex];
    final items = List<CanvasItem>.from(currentPage.items);
    
    final newItem = CanvasItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'image',
      content: imageUrl,
      x: 50,
      y: 50,
      width: 150,
      height: 150,
    );
    
    items.add(newItem);
    
    final updatedPages = List<PageModel>.from(state.pages);
    updatedPages[state.currentPageIndex] = currentPage.copyWith(items: items);
    
    state = state.copyWith(pages: updatedPages);
  }

  void updateItem(int pageIndex, CanvasItem item) {
    final pages = List<PageModel>.from(state.pages);
    final page = pages[pageIndex];
    final items = List<CanvasItem>.from(page.items);
    
    final itemIndex = items.indexWhere((i) => i.id == item.id);
    if (itemIndex >= 0) {
      items[itemIndex] = item;
    } else {
      items.add(item);
    }
    
    pages[pageIndex] = page.copyWith(items: items);
    state = state.copyWith(pages: pages);
  }
}

final editorProvider = StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier();
});
