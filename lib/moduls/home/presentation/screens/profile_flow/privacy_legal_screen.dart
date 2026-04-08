import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class PrivacyLegalScreen extends StatelessWidget {
  const PrivacyLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: AppPalette.textPrimary,
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: const Text(
          'Privacy & Legal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: const [
          Text(
            'By downloading or using this app, you agree to the terms of this Privacy Policy.',
            style: TextStyle(
              fontSize: 11,
              height: 1.45,
              color: AppPalette.textSecondary,
            ),
          ),
          SizedBox(height: 18),
          _PolicySection(
            title: '1. Company Information',
            lines: [
              'Bheppo LLC',
              'State of Delaware',
              'United States of America',
            ],
          ),
          _PolicySection(
            title: '2. Information We Collect',
            lines: [
              'We may collect the following types of information:',
              'A. Personal Information',
              '• Email address',
              '• Name (optional)',
              '• Contact details',
              '• Uploaded designs or images',
              '• Account registration info',
              'B. Payment Information',
              'Payments are processed securely through third-party services such as:',
              '• Apple App Store',
              '• Google Play',
              '• Stripe (if applicable)',
              'We do not store full card numbers.',
              'C. Usage Data',
              '• Device type',
              '• Operating system',
              '• App usage behavior',
              '• IP address',
              '• Approximate location',
              '• App crash reports',
              '• Analytics data',
              'D. User Content',
              'If you upload images (e.g., tattoo designs, sketches), we may collect and store those files to provide the service.',
            ],
          ),
          _PolicySection(
            title: '3. How We Use Your Information',
            lines: [
              'We use your information to:',
              '• Create and manage your account',
              '• Provide and improve App features',
              '• Process payments and subscriptions',
              '• Restore your stencil history',
              '• Send you legal updates',
              '• Contact you about changes',
              '• Analyze usage for improvements',
            ],
          ),
          _PolicySection(
            title: '4. Data Security',
            lines: [
              'We use reasonable security measures to protect your information, but no method of transmission or storage is 100% secure. Use the app at your own risk.',
            ],
          ),
          _PolicySection(
            title: '5. International Transfers',
            lines: [
              'If you use the App outside the United States, your data may be transferred to and processed in the U.S. where our servers or service providers are located.',
            ],
          ),
          _PolicySection(
            title: '6. Third-Party Services',
            lines: [
              'We may use third-party processors, including:',
              '• Cloud storage',
              '• Payment processors',
              '• Analytics providers (e.g., Google Analytics, Firebase)',
              '• App store infrastructure',
              'We do not sell, rent, or trade personal information.',
            ],
          ),
          _PolicySection(
            title: '7. Data Retention',
            lines: [
              'We retain your information:',
              '• While your account is active',
              '• For legal or contractual purposes',
              '• To improve service quality',
              'You may request deletion of your account at any time.',
            ],
          ),
          _PolicySection(
            title: '8. Your Rights',
            lines: [
              'Depending on your location, you may have the right to:',
              '• Access your data',
              '• Correct inaccuracies',
              '• Request deletion',
              '• Restrict processing',
              '• Object to tracking',
              'California Residents (CCPA/CPRA):',
              '• Know what personal data we collect',
              '• Access and delete data',
              '• Opt out of data selling (we do not sell data)',
              'EU Users (GDPR):',
              'If you are located in the European Union, you have rights under GDPR, including:',
              '• Access your data',
              '• Correct inaccurate info',
              '• Delete your data',
              '• Limit processing',
              '• Object to profiling',
            ],
          ),
          _PolicySection(
            title: '9. Children',
            lines: [
              'We do not knowingly collect data from users under 13. If we become aware of such data, we will delete it.',
            ],
          ),
          _PolicySection(
            title: '10. Changes to this Policy',
            lines: [
              'We may update this Privacy Policy periodically.',
              'Changes will be posted in the app or website.',
            ],
          ),
          _PolicySection(
            title: '11. Contact Us',
            lines: [
              'For any questions regarding this Privacy Policy:',
              'Bheppo LLC',
              'support@bheppo.com',
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _PolicySection({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.45,
                  color: AppPalette.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
