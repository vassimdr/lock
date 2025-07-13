import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';

class ChildDashboardScreen extends StatelessWidget {
  const ChildDashboardScreen({super.key});

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
        title: const Text('Çocuk Paneli'),
        backgroundColor: AppColors.childPrimary,
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
              // Child Dashboard Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.childPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.child_care,
                  size: 60.w,
                  color: AppColors.childPrimary,
                ),
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Welcome Title
              Text(
                'Merhaba!',
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Welcome Description
              Text(
                'Güvenli dijital deneyimin için buradayız.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Status Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Status Icon
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 30.w,
                          color: AppColors.success,
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.md),
                      
                      // Status Title
                      Text(
                        'Cihaz Koruması Aktif',
                        style: AppTextStyles.cardTitle,
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: AppSpacing.sm),
                      
                      // Status Description
                      Text(
                        'Ebeveyn kontrolü altında güvenli kullanım sağlanıyor.',
                        style: AppTextStyles.cardSubtitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Info Text
              Text(
                'Bu uygulama ebeveynin tarafından yönetilmektedir.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
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