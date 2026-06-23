/// Represents an uploaded image in the Pixovo system.
class UserImage {
  final String id;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final DateTime uploadedAt;
  final int? sizeBytes;

  const UserImage({
    required this.id,
    required this.url,
    this.thumbnailUrl,
    this.width,
    this.height,
    required this.uploadedAt,
    this.sizeBytes,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: json['id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      sizeBytes: json['size_bytes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'uploaded_at': uploadedAt.toIso8601String(),
      'size_bytes': sizeBytes,
    };
  }

  UserImage copyWith({
    String? id,
    String? url,
    String? thumbnailUrl,
    int? width,
    int? height,
    DateTime? uploadedAt,
    int? sizeBytes,
  }) {
    return UserImage(
      id: id ?? this.id,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }
}
