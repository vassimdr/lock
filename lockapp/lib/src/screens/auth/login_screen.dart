import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';
import '../../store/auth/auth_providers.dart';
import '../../types/enums/user_role.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String role;
  
  const LoginScreen({super.key, required this.role});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      
      // Convert string role to UserRole enum
      final userRole = widget.role == 'parent' ? UserRole.parent : UserRole.child;
      
      final success = await authNotifier.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        expectedRole: userRole,
      );

      if (mounted && success) {
        final authState = ref.read(authNotifierProvider);
        
        // Navigate based on user role
        if (authState.isParent) {
          AppRouter.goToParentDashboard();
        } else if (authState.isChild) {
          AppRouter.goToChildDashboard();
        }
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    
    // Listen to auth errors
    ref.listen(authErrorProvider, (previous, next) {
      if (next != null) {
        _showErrorSnackBar(next);
        // Clear error after showing
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            ref.read(authNotifierProvider.notifier).clearError();
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Giriş Yap'),
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      size: 50.w,
                      color: AppColors.primary,
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.xl),
                  
                  Text(
                    'Hoş Geldiniz',
                    style: AppTextStyles.headlineLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.sm),
                  
                  Text(
                    '${widget.role == 'parent' ? 'Ebeveyn' : 'Çocuk'} hesabınızla giriş yapın',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: AppSpacing.xxl),
                  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-posta',
                      hintText: 'ornek@email.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'E-posta gerekli';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Geçerli bir e-posta adresi girin';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: AppSpacing.lg),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Şifre',
                      hintText: 'Şifrenizi girin',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Şifre gerekli';
                      }
                      if (value.length < 6) {
                        return 'Şifre en az 6 karakter olmalı';
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: AppSpacing.xl),
                  
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleLogin,
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : const Text('Giriş Yap'),
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.md),
                  
                  // Register Link
                  TextButton(
                    onPressed: authState.isLoading ? null : () => AppRouter.goToRegister(role: widget.role),
                    child: const Text('Hesabınız yok mu? Kayıt olun'),
                  ),
                  
                  SizedBox(height: AppSpacing.md),
                  
                  // Forgot Password Link
                  TextButton(
                    onPressed: authState.isLoading ? null : () => _showForgotPasswordDialog(),
                    child: const Text('Şifremi unuttum'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Şifre Sıfırlama'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('E-posta adresinizi girin, size şifre sıfırlama bağlantısı gönderelim.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'E-posta',
                hintText: 'ornek@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                
                final authNotifier = ref.read(authNotifierProvider.notifier);
                final success = await authNotifier.resetPassword(
                  email: emailController.text.trim(),
                );
                
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Şifre sıfırlama e-postası gönderildi'),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }
}