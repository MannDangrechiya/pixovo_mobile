/// Represents an uploaded image in the Pixovo system.
class UserImage {
  final String id;
  final String url;
  final String? compressImage;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final DateTime uploadedAt;
  final int? sizeBytes;
  final bool isOrder;
  final String? imageType;

  const UserImage({
    required this.id,
    required this.url,
    this.compressImage,
    this.thumbnailUrl,
    this.width,
    this.height,
    required this.uploadedAt,
    this.sizeBytes,
    this.isOrder = false,
    this.imageType,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: json['id'] as String? ?? json['image_id'] as String? ?? '',
      url: json['url'] as String? ?? json['image'] as String? ?? '',
      compressImage: json['compress_image'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      uploadedAt: json['uploaded_at'] != null 
          ? DateTime.parse(json['uploaded_at'] as String)
          : DateTime.now(),
      sizeBytes: json['size_bytes'] as int?,
      isOrder: json['is_order'] as bool? ?? false,
      imageType: json['image_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'compress_image': compressImage,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'uploaded_at': uploadedAt.toIso8601String(),
      'size_bytes': sizeBytes,
      'is_order': isOrder,
      'image_type': imageType,
    };
  }

  UserImage copyWith({
    String? id,
    String? url,
    String? compressImage,
    String? thumbnailUrl,
    int? width,
    int? height,
    DateTime? uploadedAt,
    int? sizeBytes,
    bool? isOrder,
    String? imageType,
  }) {
    return UserImage(
      id: id ?? this.id,
      url: url ?? this.url,
      compressImage: compressImage ?? this.compressImage,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      isOrder: isOrder ?? this.isOrder,
      imageType: imageType ?? this.imageType,
    );
  }
}
