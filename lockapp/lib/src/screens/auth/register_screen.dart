import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';
import '../../store/auth/auth_providers.dart';
import '../../types/enums/user_role.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  UserRole _selectedRole = UserRole.parent;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authNotifier = ref.read(authNotifierProvider.notifier);
      
      final success = await authNotifier.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: AppSpacing.md),
                
                // App Logo
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
                  'Hesap Oluştur',
                  style: AppTextStyles.headline3,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Description
                Text(
                  'Yeni hesabınızı oluşturun',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: AppSpacing.xl),
                
                // Name Field
                TextFormField(
                  controller: _nameController,
                  enabled: !authState.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    hintText: 'Adınız ve soyadınız',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ad soyad gerekli';
                    }
                    if (value.trim().length < 2) {
                      return 'Ad soyad en az 2 karakter olmalı';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !authState.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    hintText: 'ornek@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-posta adresi gerekli';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Role Selection
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyLight),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Hesap Türü',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      ...UserRole.values.map((role) => RadioListTile<UserRole>(
                        title: Text(role.displayName),
                        subtitle: Text(role.description),
                        value: role,
                        groupValue: _selectedRole,
                        onChanged: authState.isLoading ? null : (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      )),
                    ],
                  ),
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  enabled: !authState.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    hintText: 'Şifrenizi girin',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
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
                
                SizedBox(height: AppSpacing.md),
                
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  enabled: !authState.isLoading,
                  decoration: InputDecoration(
                    labelText: 'Şifre Tekrar',
                    hintText: 'Şifrenizi tekrar girin',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre tekrarı gerekli';
                    }
                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: AppSpacing.xl),
                
                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleRegister,
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
                        : const Text('Kayıt Ol'),
                  ),
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Login Link
                TextButton(
                  onPressed: authState.isLoading ? null : () => AppRouter.goToLogin(),
                  child: const Text('Zaten hesabınız var mı? Giriş yapın'),
                ),
                
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 