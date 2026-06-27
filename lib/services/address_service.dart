import '../config/api_config.dart';
import '../models/shipping_address.dart';
import 'api_service.dart';

/// Handles shipping address CRUD against the backend API.
class AddressService {
  final ApiService _api = ApiService();

  /// Fetch all saved shipping addresses for the current user.
  Future<List<ShippingAddress>> getAddresses() async {
    final response = await _api.get(ApiConfig.shippingAddressesList);
    final list = response.data['shipping_addresses'] as List<dynamic>? ?? [];
    return list
        .map((e) => ShippingAddress.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Add a new shipping address.
  Future<ShippingAddress> addAddress(ShippingAddress address) async {
    final response = await _api.post(
      ApiConfig.addAddress,
      data: address.toJson(),
    );
    return ShippingAddress.fromJson(response.data as Map<String, dynamic>);
  }

  /// Update an existing shipping address by ID.
  Future<ShippingAddress> updateAddress(ShippingAddress address) async {
    final response = await _api.post(
      '${ApiConfig.updateAddress}/${address.id}',
      data: address.toJson(),
    );
    return ShippingAddress.fromJson(response.data as Map<String, dynamic>);
  }

  /// Delete a shipping address by ID.
  Future<void> deleteAddress(String addressId) async {
    await _api.post('${ApiConfig.deleteAddress}/$addressId');
  }
}
