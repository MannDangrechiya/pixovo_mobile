/// Represents a shipping address.
class ShippingAddress {
  final String? id;
  final String name;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final bool isDefault;

  const ShippingAddress({
    this.id,
    required this.name,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'India',
    this.phone,
    this.isDefault = false,
  });

  /// Formatted single-line address string.
  String get formattedAddress {
    final parts = [line1];
    if (line2 != null && line2!.isNotEmpty) parts.add(line2!);
    parts.addAll([city, state, zipCode, country]);
    return parts.join(', ');
  }

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] as String?,
      name: json['name'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zip_code'] as String,
      country: json['country'] as String? ?? 'India',
      phone: json['phone'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'phone': phone,
      'is_default': isDefault,
    };
  }

  ShippingAddress copyWith({
    String? id,
    String? name,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phone,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      name: name ?? this.name,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
