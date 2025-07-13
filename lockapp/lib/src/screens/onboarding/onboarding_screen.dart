import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Onboarding Icon
              Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.family_restroom,
                  size: 80.w,
                  color: AppColors.primary,
                ),
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Welcome Title
              Text(
                'Hoş Geldiniz!',
                style: AppTextStyles.headline2,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Welcome Description
              Text(
                'Çocuklarınızın dijital güvenliğini sağlamak için tasarlanmış uygulamamıza hoş geldiniz.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppRouter.goToRoleSelection(),
                  child: const Text('Devam Et'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 