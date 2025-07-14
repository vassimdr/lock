import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';
import '../../services/time_restriction_service.dart';
import '../../services/app_blocking_service.dart';
import '../../types/app_control_models.dart';

class ChildDashboardScreen extends StatefulWidget {
  const ChildDashboardScreen({super.key});

  @override
  State<ChildDashboardScreen> createState() => _ChildDashboardScreenState();
}

class _ChildDashboardScreenState extends State<ChildDashboardScreen> {
  final TimeRestrictionService _timeRestrictionService = TimeRestrictionService();
  final AppBlockingService _appBlockingService = AppBlockingService();
  
  List<TimeRestriction> _activeRestrictions = [];
  List<AppBlockRule> _blockedApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestrictions();
  }

  Future<void> _loadRestrictions() async {
    try {
      final restrictions = await _timeRestrictionService.getActiveTimeRestrictions(childUserId: 'child1');
      final blockedApps = await _appBlockingService.getBlockRules(childUserId: 'child1');
      
      setState(() {
        _activeRestrictions = restrictions;
        _blockedApps = blockedApps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading restrictions: $e');
    }
  }

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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.childPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.childPrimary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hoş Geldin! 👋',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.childPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cihazın güvenli kullanım altında',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Current restrictions section
                    Text(
                      'Aktif Kısıtlamalar',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_activeRestrictions.isEmpty && _blockedApps.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 48,
                              color: AppColors.success,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Şu anda aktif kısıtlama yok',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tüm uygulamaları serbestçe kullanabilirsin',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          // Blocked apps
                          if (_blockedApps.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.error.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.block,
                                        color: AppColors.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Engellenmiş Uygulamalar',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...(_blockedApps.take(3).map((app) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: app.appIcon != null && app.appIcon!.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.memory(
                                                    base64Decode(app.appIcon!),
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.android,
                                                  color: AppColors.textSecondary,
                                                  size: 20,
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            app.appName,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Engellendi',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.error,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                                  if (_blockedApps.length > 3)
                                    Text(
                                      '... ve ${_blockedApps.length - 3} uygulama daha',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          // Time restrictions
                          if (_activeRestrictions.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.warning.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        color: AppColors.warning,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Zaman Kısıtlamaları',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.warning,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...(_activeRestrictions.take(3).map((restriction) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: restriction.appIcon != null && restriction.appIcon!.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.memory(
                                                    base64Decode(restriction.appIcon!),
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.android,
                                                  color: AppColors.textSecondary,
                                                  size: 20,
                                                ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                restriction.appName,
                                                style: AppTextStyles.bodyMedium.copyWith(
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              Text(
                                                '${restriction.startTime} - ${restriction.endTime}',
                                                style: AppTextStyles.bodySmall.copyWith(
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          restriction.formattedDailyLimit,
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.warning,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                                  if (_activeRestrictions.length > 3)
                                    Text(
                                      '... ve ${_activeRestrictions.length - 3} kısıtlama daha',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildRestrictionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.childPrimary,
                  size: 24.w,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Aktif Kısıtlamalar',
                  style: AppTextStyles.cardTitle,
                ),
              ],
            ),
            
            SizedBox(height: AppSpacing.md),
            
            // Blocked Apps
            if (_blockedApps.isNotEmpty) ...[
              Text(
                'Engellenen Uygulamalar (${_blockedApps.length})',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.red[700],
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              ...(_blockedApps.take(3).map((app) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red, size: 16.w),
                    SizedBox(width: AppSpacing.xs),
                    Text(app.appName, style: AppTextStyles.bodySmall),
                  ],
                ),
              ))),
              if (_blockedApps.length > 3)
                Text(
                  '... ve ${_blockedApps.length - 3} uygulama daha',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
            
            // Time Restrictions
            if (_activeRestrictions.isNotEmpty) ...[
              if (_blockedApps.isNotEmpty) SizedBox(height: AppSpacing.md),
              Text(
                'Zaman Kısıtlamaları (${_activeRestrictions.length})',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.orange[700],
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              ...(_activeRestrictions.take(3).map((restriction) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.orange, size: 16.w),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        '${restriction.appName} - ${restriction.startTime} - ${restriction.endTime}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ))),
              if (_activeRestrictions.length > 3)
                Text(
                  '... ve ${_activeRestrictions.length - 3} kısıtlama daha',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ],
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