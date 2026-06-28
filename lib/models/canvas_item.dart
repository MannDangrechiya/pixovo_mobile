/// Represents an item on a photobook page (photo, text, sticker).
class CanvasItem {
  final String id;
  final String type; // 'image', 'text', 'sticker'
  final String? content; // url for image/sticker, string for text
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation; // in radians
  final Map<String, dynamic> metadata; // e.g., color, font, etc.

  const CanvasItem({
    required this.id,
    required this.type,
    this.content,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0.0,
    this.metadata = const {},
  });

  factory CanvasItem.fromJson(Map<String, dynamic> json) {
    return CanvasItem(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String?,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'rotation': rotation,
      'metadata': metadata,
    };
  }

  CanvasItem copyWith({
    String? id,
    String? type,
    String? content,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
    Map<String, dynamic>? metadata,
  }) {
    return CanvasItem(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
      metadata: metadata ?? this.metadata,
    );
  }
}
