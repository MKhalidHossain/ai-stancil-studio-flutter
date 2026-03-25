import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';

class PricingPlanScreen extends StatelessWidget {
  const PricingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Unlock Premium Features',
          style: TextStyle(color: AppPalette.textPrimary, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Start your 3-day free trial today',
                style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
              ),
              const SizedBox(height: 12),
              Obx(() {
                final isMonthly = controller.selectedPlanIndex.value == 0;
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppPalette.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _PlanToggleChip(
                          title: 'Monthly',
                          subtitle: '\$9.99/mo',
                          isSelected: isMonthly,
                          onTap: () => controller.selectedPlanIndex.value = 0,
                        ),
                      ),
                      Expanded(
                        child: _PlanToggleChip(
                          title: 'Yearly',
                          subtitle: '\$8.25/mo',
                          isSelected: !isMonthly,
                          onTap: () => controller.selectedPlanIndex.value = 1,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                final plan =
                    controller.plans[controller.selectedPlanIndex.value];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppPalette.purpleSoft,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppPalette.purpleBorder),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppPalette.purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        plan.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: AppPalette.textPrimary),
                          children: [
                            TextSpan(
                              text: plan.price,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: plan.periodLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppPalette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (plan.savings.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          plan.savings,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppPalette.purple,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.timelapse,
                              size: 16,
                              color: AppPalette.purple,
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '3-Day Free Trial',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Cancel anytime',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppPalette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      HomePrimaryButton(
                        text: 'Start Free Trial',
                        onTap: () => Get.toNamed(HomeRoutes.payment),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your subscription begins after 3 days. Cancel anytime before trial ends, no charges. After trial: \$9.99/month',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              const _InfoCard(
                title: 'Subscription Details',
                lines: [
                  'All subscriptions renew automatically',
                  'Subscriptions are billed in advance',
                  'Must be cancelled via Apple App Store or Google Play Store',
                ],
              ),
              const SizedBox(height: 12),
              const _InfoCard(
                title: 'Refund Policy',
                highlight: true,
                lines: [
                  'Refunds are processed by Bheppo LLC through Stripe',
                  'Cancel during the trial period - no charges applied',
                  'Contact support@bheppo.com for refund requests',
                ],
              ),
              const SizedBox(height: 12),
              const _InfoCard(
                title: 'Secure Payment',
                lines: [
                  'Payments are processed securely through Stripe, Inc.',
                  'Bheppo LLC does not store full credit card information.',
                ],
                footer: 'Secure Payments',
              ),
              const SizedBox(height: 12),
              const Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: AppPalette.textSecondary),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Bheppo LLC © 2026',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppPalette.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanToggleChip extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanToggleChip({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppPalette.purple : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : AppPalette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<String> lines;
  final String? footer;
  final bool highlight;

  const _InfoCard({
    required this.title,
    required this.lines,
    this.footer,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFF3D6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 11)),
                  Expanded(
                    child: Text(
                      line,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppPalette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.shield_outlined, size: 14, color: AppPalette.purple),
                SizedBox(width: 6),
                Text(
                  'Secure Payments',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
