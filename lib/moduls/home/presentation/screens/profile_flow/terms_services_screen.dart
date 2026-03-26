import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class TermsServicesScreen extends StatelessWidget {
  const TermsServicesScreen({super.key});

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
          'Terms and services',
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
            'By downloading or using the app, you agree to these Terms.',
            style: TextStyle(
              fontSize: 11,
              height: 1.45,
              color: AppPalette.textSecondary,
            ),
          ),
          SizedBox(height: 18),
          _TermsSection(
            title: '1. Eligibility',
            lines: [
              'You must be at least 18 years old to use this App.',
              'By using the App, you confirm you are legally capable of entering into a binding agreement.',
            ],
          ),
          _TermsSection(
            title: '2. Description of Service',
            lines: [
              'Bheppo Stencil App provides:',
              '• Image-to-stencil conversion tools',
              '• Tattoo design enhancement features',
              '• Custom image generation features',
              '• Photo upload and processing',
              '• Account-based sync of saved results',
            ],
          ),
          _TermsSection(
            title: '3. Account Registration',
            lines: [
              'You may need to create an account.',
              'You are responsible for:',
              '• Maintaining login credentials',
              '• Keeping your password secure',
              '• Providing valid information',
            ],
          ),
          _TermsSection(
            title: '4. Subscription & Billing',
            lines: [
              'The App offers:',
              '• Free access',
              '• Paid subscription tiers',
              '• Auto-renew subscriptions',
              'Subscriptions renew automatically unless canceled through your Google account.',
              'Your account may be charged via:',
              '• Apple App Store',
              '• Google Play Store',
              '• Stripe (if any)',
              '• Other app stores',
              'No refunds are guaranteed unless required by law.',
            ],
          ),
          _TermsSection(
            title: '5. Intellectual Property & Artwork Ownership',
            lines: [
              'You retain full ownership of any artwork, designs, or images uploaded.',
              'Bheppo does not claim ownership of your work.',
              'However:',
              'Bheppo may process the images you upload for internal application improvement, new feature development, and service optimization, but only for your direct App functionality.',
              'Ads/AI:',
              'Ads may display around the app.',
              'The processing of your content, including uploaded artwork and app interactions, may be used to train internal AI or machine learning models to enhance the app\'s performance, develop new features, personalize user experience, and improve service quality.',
            ],
          ),
          _TermsSection(
            title: '6. AI PROCESSING DISCLOSURE',
            lines: [
              'The App uses AI-assisted image processing and AI-generated artwork tools.',
              'The App is not intended for individuals under 16 years of age.',
            ],
          ),
          _TermsSection(
            title: '7. Prohibited Use',
            lines: [
              'You may not:',
              '• Upload illegal content',
              '• Infringe copyrights or trademarks',
              '• Reverse engineer the app',
              '• Abuse the service or upload spam',
              '• Use the app for unlawful purposes',
            ],
          ),
          _TermsSection(
            title: '8. Refund Policy',
            lines: [
              'Because subscriptions are processed through Apple App Store, Google Play, or Stripe, refund decisions are made by those platforms.',
            ],
          ),
          _TermsSection(
            title: '9. Limitation of Liability',
            lines: [
              'The App is provided "as is".',
              'Bheppo LLC is not liable for:',
              '• Loss of data',
              '• Tattoo application errors',
              '• Payment or billing issues',
              '• Harm caused by AI failures or bugs',
            ],
          ),
          _TermsSection(
            title: '10. Termination',
            lines: [
              'We may suspend or terminate accounts that violate these Terms.',
              'You may delete your account at any time.',
            ],
          ),
          _TermsSection(
            title: '11. Governing Law',
            lines: [
              'These Terms are governed by the laws of the State of New Jersey, United States.',
              'Any disputes shall be resolved in New Jersey courts.',
            ],
          ),
          _TermsSection(
            title: '12. Contact',
            lines: [
              'Bheppo LLC',
              'New Jersey, U.S.A',
              'support@bheppo.com',
            ],
          ),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _TermsSection({required this.title, required this.lines});

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
