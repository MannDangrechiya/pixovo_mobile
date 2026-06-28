import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';

/// User profile screen with info display, edit, and logout.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFFE94560).withValues(alpha: 0.1),
              backgroundImage:
                  user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null,
              child: user?.avatarUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFFE94560),
                    )
                  : null,
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user?.name ?? 'User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),

            // Menu items
            _ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () => context.push(AppRoutes.editProfile),
            ),
            _ProfileMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'My Orders',
              onTap: () => context.push(AppRoutes.orderList),
            ),
            _ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              onTap: () => context.push(AppRoutes.addressBook),
            ),
            _ProfileMenuItem(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () => context.push(AppRoutes.paymentMethods),
            ),
            _ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => context.push(AppRoutes.settings),
            ),
            _ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () => context.push(AppRoutes.helpSupport),
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                // Navigate to about
              },
            ),
            const SizedBox(height: 16),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content:
                          const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE94560).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFE94560)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
