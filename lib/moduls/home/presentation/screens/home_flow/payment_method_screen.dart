import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(color: AppPalette.textPrimary, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final plan = controller.selectedPlan;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.checkoutHeadline,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plan.checkoutSummary,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppPalette.textSecondary,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              const Text(
                'Payment method',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPalette.cardBorder),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => selected = 0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppPalette.purple, width: 1.5),
                        ),
                        child: selected == 0
                            ? const Center(
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: AppPalette.purple,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Stripe Checkout',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => HomePrimaryButton(
                  text: controller.isCreatingCheckoutSession.value
                      ? 'Opening Stripe...'
                      : 'Continue to Stripe',
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  onTap: controller.isCreatingCheckoutSession.value
                      ? null
                      : () async {
                          final opened = await controller.openCheckoutSession();
                          if (!opened) {
                            return;
                          }
                          if (!mounted) {
                            return;
                          }
                          Get.snackbar(
                            'Checkout opened',
                            'After finishing in Stripe, return here and tap "I completed payment".',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                ),
              ),
              const SizedBox(height: 12),
              HomePrimaryButton(
                text: 'I completed payment',
                onTap: () async {
                  await controller.syncSubscriptionStatus();
                  if (controller.hasActivePlan.value && mounted) {
                    Get.back();
                    Get.back();
                  }
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Stripe opens in your browser. Once checkout is complete, return to the app to refresh your premium status.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppPalette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
