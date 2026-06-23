/// Represents a photo book template.
class Template {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<String> previewImages;
  final String category;
  final int pageCount;
  final double price;
  final String? currency;

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.previewImages = const [],
    required this.category,
    required this.pageCount,
    required this.price,
    this.currency = 'INR',
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
      pageCount: json['page_count'] as int,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
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
      'page_count': pageCount,
      'price': price,
      'currency': currency,
    };
  }

  Template copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    List<String>? previewImages,
    String? category,
    int? pageCount,
    double? price,
    String? currency,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewImages: previewImages ?? this.previewImages,
      category: category ?? this.category,
      pageCount: pageCount ?? this.pageCount,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }
}
