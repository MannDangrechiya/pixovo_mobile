import 'canvas_item.dart';

/// Represents a page in a photobook order.
class PageModel {
  final int pageNumber;
  final String? layoutId;
  final String? backgroundColor;
  final List<CanvasItem> items;

  const PageModel({
    required this.pageNumber,
    this.layoutId,
    this.backgroundColor,
    this.items = const [],
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      pageNumber: json['page_number'] as int,
      layoutId: json['layout'] as String?,
      backgroundColor: json['background_color'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CanvasItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page_number': pageNumber,
      'layout': layoutId,
      'background_color': backgroundColor,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  PageModel copyWith({
    int? pageNumber,
    String? layoutId,
    String? backgroundColor,
    List<CanvasItem>? items,
  }) {
    return PageModel(
      pageNumber: pageNumber ?? this.pageNumber,
      layoutId: layoutId ?? this.layoutId,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      items: items ?? this.items,
    );
  }
}
