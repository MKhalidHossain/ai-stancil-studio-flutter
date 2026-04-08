import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';

class HomeHeroCard extends StatelessWidget {
  final VoidCallback onTryGallery;
  final double height;

  const HomeHeroCard({
    super.key,
    required this.onTryGallery,
    this.height = 170,
  });

  @override
  Widget build(BuildContext context) {
    const radius = 20.0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              child: Image.asset(
                AppImages.homeGenerateTattoBackground,
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.78),
                    Colors.black.withValues(alpha: 0.52),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topRight,
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generate Your Tattoo Stencil',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload any image and convert it into a professional tattoo stencil in seconds.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: Colors.white70,
                      ),
                    ),
                    const Spacer(),
                    HomePrimaryButton(
                      text: 'Try the Gallery for free',
                      height: 42,
                      radius: 24,
                      width: double.infinity,
                      onTap: onTryGallery,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
