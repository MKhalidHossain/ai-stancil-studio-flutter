import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/stripe_success_dialog.dart';

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
          'Monthly Plan',
          style: TextStyle(color: AppPalette.textPrimary, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Try Bheppo stencil app Monthly Plan',
                style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
              ),
              const SizedBox(height: 6),
              const Text(
                r'Then $9.99/mo per week starting 3 March 2026',
                style: TextStyle(fontSize: 11, color: AppPalette.textSecondary),
              ),
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
                    Radio<int>(
                      value: 0,
                      groupValue: selected,
                      onChanged: (value) =>
                          setState(() => selected = value ?? 0),
                      activeColor: AppPalette.purple,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'stripe',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              HomePrimaryButton(
                text: 'Pay with Stripe',
                icon: const Icon(Icons.auto_awesome, size: 16),
                onTap: () async {
                  controller.setActivePlan(true);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const StripeSuccessDialog(),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) {
                    Get.back();
                    Get.back();
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
