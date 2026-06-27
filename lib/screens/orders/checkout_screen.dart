import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../models/shipping_address.dart';
import '../../models/payment.dart';
import '../../providers/order_provider.dart';
import '../../providers/address_provider.dart';
import '../../widgets/add_address_sheet.dart';

/// Checkout screen — three steps: Address → Review → Payment.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.upi;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressProvider.notifier).loadAddresses();
    });
  }

  Future<void> _handlePlaceOrder() async {
    final addrState = ref.read(addressProvider);
    if (addrState.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address.')),
      );
      setState(() => _currentStep = 0);
      return;
    }

    final orderState = ref.read(orderProvider);
    if (orderState.cartItems.isEmpty) return;

    final order = await ref.read(orderProvider.notifier).placeOrder(
          templateId: orderState.cartItems.first.templateId,
          shippingAddressId: addrState.selectedAddress!.id ?? '',
        );

    if (!mounted) return;

    if (order != null) {
      // Navigate to payment gateway screen.
      context.push(
        '${AppRoutes.payment}?orderId=${order.id}&amount=${order.totalAmount}',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(orderProvider).errorMessage ?? 'Failed to place order.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _openAddSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddAddressSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);
    final addrState = ref.watch(addressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (addrState.selectedAddress == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select a delivery address.')),
              );
              return;
            }
            setState(() => _currentStep = 1);
          } else if (_currentStep == 1) {
            setState(() => _currentStep = 2);
          } else {
            _handlePlaceOrder();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            context.pop();
          }
        },
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) {
          final isLast = _currentStep == 2;
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: orderState.isLoading ? null : details.onStepContinue,
                    child: orderState.isLoading && isLast
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(isLast ? 'Place Order' : 'Continue'),
                  ),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            ),
          );
        },
        steps: [
          // ── Step 1: Select Address ──────────────────────────────────
          Step(
            title: const Text('Delivery Address'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (addrState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (addrState.addresses.isEmpty)
                  Column(
                    children: [
                      const Text('No saved addresses. Add one to continue.'),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _openAddSheet,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Address'),
                      ),
                    ],
                  )
                else ...[
                  ...addrState.addresses.map((addr) => _AddressTile(
                        address: addr,
                        isSelected: addrState.selectedAddress?.id == addr.id,
                        onTap: () =>
                            ref.read(addressProvider.notifier).selectAddress(addr),
                      )),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _openAddSheet,
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Address'),
                  ),
                ],
              ],
            ),
          ),

          // ── Step 2: Review Order ───────────────────────────────────
          Step(
            title: const Text('Review Order'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Summary',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...orderState.cartItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${item.templateName} x${item.quantity}'),
                          ),
                          Text(
                            '₹${item.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '₹${orderState.cartTotal.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (addrState.selectedAddress != null) ...[
                  Text(
                    'Shipping to:',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${addrState.selectedAddress!.name}\n'
                    '${addrState.selectedAddress!.formattedAddress}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Step 3: Payment Method ─────────────────────────────────
          Step(
            title: const Text('Payment'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Payment Method',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _PaymentMethodTile(
                  label: 'UPI',
                  icon: Icons.currency_rupee,
                  value: PaymentMethod.upi,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                ),
                _PaymentMethodTile(
                  label: 'Credit / Debit Card',
                  icon: Icons.credit_card,
                  value: PaymentMethod.card,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                ),
                _PaymentMethodTile(
                  label: 'Net Banking',
                  icon: Icons.account_balance_outlined,
                  value: PaymentMethod.netBanking,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                ),
                _PaymentMethodTile(
                  label: 'Wallet',
                  icon: Icons.account_balance_wallet_outlined,
                  value: PaymentMethod.wallet,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                ),
                _PaymentMethodTile(
                  label: 'Cash on Delivery',
                  icon: Icons.local_shipping_outlined,
                  value: PaymentMethod.cod,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address Tile ──────────────────────────────────────────────────────────────

class _AddressTile extends StatelessWidget {
  final ShippingAddress address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<bool>(
        value: true,
        groupValue: isSelected,
        onChanged: (_) => onTap(),
        activeColor: theme.colorScheme.primary,
        title: Row(
          children: [
            Text(
              address.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (address.isDefault) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            address.formattedAddress,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Payment Method Tile ───────────────────────────────────────────────────────

class _PaymentMethodTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final PaymentMethod value;
  final PaymentMethod groupValue;
  final ValueChanged<PaymentMethod?> onChanged;

  const _PaymentMethodTile({
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<PaymentMethod>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
        title: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
