/// Represents a photo book template.
class Template {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<String> previewImages;
  final String category;
  final int minPage;
  final int maxPage;
  final double basePrice;
  final double perPagePrice;
  final String? currency;
  final List<String> sizes;
  final List<String> coverTypes;
  final List<String> paperQualities;

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.previewImages = const [],
    required this.category,
    required this.minPage,
    required this.maxPage,
    required this.basePrice,
    required this.perPagePrice,
    this.currency = 'USD',
    this.sizes = const [],
    this.coverTypes = const [],
    this.paperQualities = const [],
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      previewImages: (json['preview_images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      category: json['category'] as String,
      minPage: json['min_page'] as int? ?? json['page_count'] as int? ?? 10,
      maxPage: json['max_page'] as int? ?? 100,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? 0.0,
      perPagePrice: (json['per_page_price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      sizes: (json['sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['available_sizes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
      coverTypes: (json['cover_types'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['available_covers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
      paperQualities: (json['paper_qualities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'preview_images': previewImages,
      'category': category,
      'min_page': minPage,
      'max_page': maxPage,
      'base_price': basePrice,
      'per_page_price': perPagePrice,
      'currency': currency,
      'sizes': sizes,
      'cover_types': coverTypes,
      'paper_qualities': paperQualities,
    };
  }

  Template copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    List<String>? previewImages,
    String? category,
    int? minPage,
    int? maxPage,
    double? basePrice,
    double? perPagePrice,
    String? currency,
    List<String>? sizes,
    List<String>? coverTypes,
    List<String>? paperQualities,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewImages: previewImages ?? this.previewImages,
      category: category ?? this.category,
      minPage: minPage ?? this.minPage,
      maxPage: maxPage ?? this.maxPage,
      basePrice: basePrice ?? this.basePrice,
      perPagePrice: perPagePrice ?? this.perPagePrice,
      currency: currency ?? this.currency,
      sizes: sizes ?? this.sizes,
      coverTypes: coverTypes ?? this.coverTypes,
      paperQualities: paperQualities ?? this.paperQualities,
    );
  }
}
