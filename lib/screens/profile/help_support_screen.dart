import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.headset_mic_outlined, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our support team is available 24/7 to assist you with any queries.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE94560),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: const Text('Start Live Chat', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          const Padding(
            padding: EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              'FAQ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          
          _buildFaqItem(
            question: 'How do I track my order?',
            answer: 'You can track your order by going to "My Orders" in your profile and tapping on the specific order. Tracking details will be available once the order is shipped.',
          ),
          _buildFaqItem(
            question: 'What is the return policy?',
            answer: 'Since our products are custom made, we only accept returns for items that are defective or damaged upon arrival. Please contact support within 7 days of receiving your order.',
          ),
          _buildFaqItem(
            question: 'How long does shipping take?',
            answer: 'Standard shipping usually takes 5-7 business days. Expedited shipping options are available at checkout.',
          ),
          _buildFaqItem(
            question: 'Can I change my delivery address?',
            answer: 'You can change your delivery address within 24 hours of placing the order by contacting our support team.',
          ),
          
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          
          _buildContactCard(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'support@pixovo.com',
            onTap: () {},
          ),
          _buildContactCard(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '+1 (800) 123-4567',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
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
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFFE94560),
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(color: Colors.grey.shade600, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE94560).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFE94560)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
