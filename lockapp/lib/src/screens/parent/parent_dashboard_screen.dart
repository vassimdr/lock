import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../navigation/app_router.dart';
import '../../services/permission_service.dart';
import '../../services/usage_stats_service.dart';
import '../../types/app_usage_stats.dart';
import 'usage_statistics_screen.dart';
import 'app_blocking_screen.dart';
import 'time_restriction_screen.dart';

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                  title: 'Çocuk Cihazı Eşleştir',
                  description: 'QR kod ile çocuk cihazını eşleştirin',
                  icon: Icons.qr_code_2,
                  color: AppColors.parentPrimary,
                  onTap: () {
                    AppRouter.goToQrGeneration();
                  },
                ),
                
                SizedBox(height: AppSpacing.md),
                
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
                
                _UsageStatsCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UsageStatisticsScreen(),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppSpacing.md),
                
                _FeatureCard(
                  title: 'Uygulama Kilidi',
                  description: 'Uygulamaları uzaktan kilitleyin',
                  icon: Icons.lock,
                  color: AppColors.warning,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppBlockingScreen(),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppSpacing.md),
                
                _FeatureCard(
                  title: 'Zaman Kısıtlamaları',
                  description: 'Uygulama kullanım saatlerini belirleyin',
                  icon: Icons.schedule,
                  color: AppColors.info,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeRestrictionScreen(),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: AppSpacing.xl),
                
                // Quick Actions
                _QuickActionsSection(),
                
                SizedBox(height: AppSpacing.xl),
              ],
            ),
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
              // TODO: Implement exit logic
            },
            child: const Text('Çıkış'),
          ),
        ],
      ),
    );
  }
}

// Feature Card Widget
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
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
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

// Enhanced Usage Statistics Card
class _UsageStatsCard extends StatefulWidget {
  final VoidCallback onTap;

  const _UsageStatsCard({required this.onTap});

  @override
  State<_UsageStatsCard> createState() => _UsageStatsCardState();
}

class _UsageStatsCardState extends State<_UsageStatsCard> {
  final UsageStatsService _usageStatsService = UsageStatsService();
  DailyUsageSummary? _todaysSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodaysStats();
  }

  Future<void> _loadTodaysStats() async {
    try {
      final summary = await _usageStatsService.generateDailyUsageSummary(
        childUserId: 'demo_child_001', // TODO: Get from auth state
        date: DateTime.now(),
      );
      if (mounted) {
        setState(() {
          _todaysSummary = summary;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.analytics,
                      size: 24.w,
                      color: AppColors.info,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kullanım İstatistikleri',
                          style: AppTextStyles.cardTitle,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Bugünkü uygulama kullanım durumu',
                          style: AppTextStyles.cardSubtitle,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Stats Content
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_todaysSummary != null)
                _buildStatsContent()
              else
                _buildEmptyState(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsContent() {
    return Column(
      children: [
        // Today's Summary Row
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'Toplam Süre',
                _todaysSummary!.formattedTotalScreenTime,
                Icons.access_time,
                AppColors.success,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatItem(
                'Uygulama Sayısı',
                '${_todaysSummary!.uniqueAppsUsed}',
                Icons.apps,
                AppColors.info,
              ),
            ),
          ],
        ),
        
        if (_todaysSummary!.topApps.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          
          // Top Apps Preview
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'En Çok Kullanılan Uygulamalar',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                
                // Top 3 Apps
                ...(_todaysSummary!.topApps.take(3).map((app) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.apps,
                          size: 16.w,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          app.appName,
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        app.formattedDuration,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ))),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16.w,
                color: color,
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 48.w,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Henüz veri yok',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Detaylar için tıklayın',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Actions Section
class _QuickActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hızlı Eylemler',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.sync,
                label: 'Verileri Senkronize Et',
                color: AppColors.info,
                onTap: () {
                  _syncAllData(context);
                },
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.settings,
                label: 'Ayarlar',
                color: AppColors.textSecondary,
                onTap: () {
                  // TODO: Navigate to settings
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  static void _syncAllData(BuildContext context) {
    // Show sync dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Veri Senkronizasyonu'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Veriler senkronize ediliyor...'),
          ],
        ),
      ),
    );
    
    // Simulate sync process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veriler başarıyla senkronize edildi'),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }
}

// Quick Action Button
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: 20.w,
                  color: color,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 