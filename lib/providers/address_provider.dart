import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shipping_address.dart';
import '../services/address_service.dart';

/// State for shipping address management.
class AddressState {
  final List<ShippingAddress> addresses;
  final ShippingAddress? selectedAddress;
  final bool isLoading;
  final String? errorMessage;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
    this.errorMessage,
  });

  AddressState copyWith({
    List<ShippingAddress>? addresses,
    ShippingAddress? selectedAddress,
    bool? isLoading,
    String? errorMessage,
    bool clearSelectedAddress = false,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress:
          clearSelectedAddress ? null : selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Manages saved shipping addresses and checkout selection.
class AddressNotifier extends StateNotifier<AddressState> {
  final AddressService _addressService;

  AddressNotifier(this._addressService) : super(const AddressState());

  /// Load all addresses for the current user.
  Future<void> loadAddresses() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final addresses = await _addressService.getAddresses();
      // Auto-select the default address if none selected yet.
      final defaultAddr = addresses.firstWhere(
        (a) => a.isDefault,
        orElse: () => addresses.isNotEmpty ? addresses.first : _emptyAddress,
      );
      state = state.copyWith(
        addresses: addresses,
        selectedAddress: state.selectedAddress ?? 
            (addresses.isNotEmpty ? defaultAddr : null),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Save a new shipping address.
  Future<ShippingAddress?> addAddress(ShippingAddress address) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final saved = await _addressService.addAddress(address);
      state = state.copyWith(
        addresses: [...state.addresses, saved],
        selectedAddress: state.selectedAddress ?? saved,
        isLoading: false,
      );
      return saved;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  /// Delete an existing shipping address.
  Future<void> deleteAddress(String addressId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _addressService.deleteAddress(addressId);
      final updated = state.addresses.where((a) => a.id != addressId).toList();
      state = state.copyWith(
        addresses: updated,
        selectedAddress: state.selectedAddress?.id == addressId
            ? (updated.isNotEmpty ? updated.first : null)
            : state.selectedAddress,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Select an address as the active checkout address.
  void selectAddress(ShippingAddress address) {
    state = state.copyWith(selectedAddress: address);
  }
}

// Placeholder to satisfy type constraints when no addresses exist.
const _emptyAddress = ShippingAddress(
  name: '',
  line1: '',
  city: '',
  state: '',
  zipCode: '',
);

/// Provider for AddressService.
final addressServiceProvider = Provider<AddressService>((ref) {
  return AddressService();
});

/// Provider for AddressNotifier.
final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier(ref.read(addressServiceProvider));
});
