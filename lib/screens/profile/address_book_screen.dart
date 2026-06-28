import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Address Book', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAddressCard(
            context: context,
            name: 'John Doe',
            type: 'Home',
            address: '123 Main Street, Apt 4B\nNew York, NY 10001',
            phone: '+1 234 567 8900',
            isDefault: true,
          ),
          _buildAddressCard(
            context: context,
            name: 'John Doe',
            type: 'Office',
            address: '456 Tech Park, Building C\nSan Francisco, CA 94105',
            phone: '+1 987 654 3210',
            isDefault: false,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Color(0xFFE94560)),
              label: const Text('Add New Address', style: TextStyle(color: Color(0xFFE94560), fontWeight: FontWeight.w600, fontSize: 16)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE94560), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required BuildContext context,
    required String name,
    required String type,
    required String address,
    required String phone,
    required bool isDefault,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDefault ? Border.all(color: const Color(0xFFE94560), width: 1.5) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1A2E)),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
                if (isDefault)
                  const Icon(Icons.check_circle, color: Color(0xFFE94560), size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Phone: $phone',
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF1A1A2E)),
                ),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
