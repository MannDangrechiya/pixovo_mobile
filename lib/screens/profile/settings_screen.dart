import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _orderUpdates = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive alerts on your device',
            value: _pushNotifications,
            onChanged: (val) => setState(() => _pushNotifications = val),
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive offers and updates via email',
            value: _emailNotifications,
            onChanged: (val) => setState(() => _emailNotifications = val),
          ),
          _buildSwitchTile(
            title: 'Order Updates',
            subtitle: 'Get notified about your order status',
            value: _orderUpdates,
            onChanged: (val) => setState(() => _orderUpdates = val),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Appearance'),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Use dark theme across the app',
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Account'),
          _buildActionTile(
            title: 'Change Password',
            icon: Icons.lock_outline,
            onTap: () {},
          ),
          _buildActionTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {},
          ),
          _buildActionTile(
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          
          Center(
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFFE94560),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE94560).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFE94560), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
