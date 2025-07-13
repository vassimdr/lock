import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Rol Seçimi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              AppRouter.goToOnboarding();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'Hangi rolde kullanacaksınız?',
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Subtitle
              Text(
                'Uygulamanın size özel özelliklerini kullanabilmek için rolünüzü seçin.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Parent Role Card
              _RoleCard(
                title: 'Ebeveyn',
                description: 'Çocuğunuzun cihazını kontrol edin ve yönetin',
                icon: Icons.supervisor_account,
                color: AppColors.parentPrimary,
                onTap: () => AppRouter.goToLogin(),
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Child Role Card
              _RoleCard(
                title: 'Çocuk',
                description: 'Ebeveyn kontrolü altında güvenli kullanım',
                icon: Icons.child_care,
                color: AppColors.childPrimary,
                onTap: () => AppRouter.goToLogin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40.w,
                  color: color,
                ),
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Title
              Text(
                title,
                style: AppTextStyles.headline5,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.sm),
              
              // Description
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 