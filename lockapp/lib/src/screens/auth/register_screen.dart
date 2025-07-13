import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              AppRouter.goToRoleSelection();
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
              // Register Icon
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_add,
                  size: 50.w,
                  color: AppColors.secondary,
                ),
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Title
              Text(
                'Kayıt Ol',
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Description
              Text(
                'Yeni hesap oluşturun',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Placeholder text
              Text(
                'Kayıt ekranı yakında gelecek...',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: AppSpacing.xl),
              
              // Back to Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppRouter.goToLogin(),
                  child: const Text('Giriş Ekranına Dön'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 