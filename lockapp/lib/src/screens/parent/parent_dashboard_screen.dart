import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';
import '../../services/permission_service.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent default back behavior
      onPopInvoked: (didPop) {
        if (!didPop) {
          _showExitDialog(context);
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ebeveyn Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dashboard Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.parentPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.dashboard,
                  size: 60.w,
                  color: AppColors.parentPrimary,
                ),
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Welcome Title
              Text(
                'Ebeveyn Kontrol Paneli',
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Welcome Description
              Text(
                'Çocuğunuzun dijital aktivitelerini buradan yönetebilirsiniz.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Feature Cards
              _FeatureCard(
                title: 'İzinleri Kontrol Et',
                description: 'Gerekli izinleri kontrol edin ve yönetin',
                icon: Icons.security,
                color: AppColors.warning,
                onTap: () {
                  AppRouter.goToPermissions();
                },
              ),
              
              SizedBox(height: AppSpacing.md),
              
              _FeatureCard(
                title: 'Kullanım İstatistikleri',
                description: 'Uygulama kullanım raporlarını görüntüleyin',
                icon: Icons.analytics,
                color: AppColors.info,
                onTap: () {
                  // TODO: Navigate to usage stats
                },
              ),
              
              SizedBox(height: AppSpacing.md),
              
              _FeatureCard(
                title: 'Uygulama Kilidi',
                description: 'Uygulamaları uzaktan kilitleyin',
                icon: Icons.lock,
                color: AppColors.warning,
                onTap: () {
                  // TODO: Navigate to app locking
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış'),
        content: const Text('Uygulamadan çıkmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to role selection
              AppRouter.goToRoleSelection();
            },
            child: const Text('Çıkış'),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Icon
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24.w,
                  color: color,
                ),
              ),
              
              SizedBox(width: AppSpacing.md),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: AppTextStyles.cardSubtitle,
                    ),
                  ],
                ),
              ),
              
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 