import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/app_blocking_service.dart';
import '../../types/app_control_models.dart';

class AppBlockingScreen extends StatefulWidget {
  final String? childUserId;

  const AppBlockingScreen({super.key, this.childUserId});

  @override
  State<AppBlockingScreen> createState() => _AppBlockingScreenState();
}

class _AppBlockingScreenState extends State<AppBlockingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppBlockingService _appBlockingService = AppBlockingService();
  
  List<Map<String, dynamic>> _installedApps = [];
  List<AppBlockRule> _blockRules = [];
  List<BlockAttemptLog> _blockLogs = [];
  bool _isLoading = false;
  bool _hasDeviceAdminPermission = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkPermissionAndLoadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionAndLoadData() async {
    setState(() => _isLoading = true);
    
    try {
      _hasDeviceAdminPermission = await _appBlockingService.hasDeviceAdminPermission();
      
      if (_hasDeviceAdminPermission) {
        await _loadData();
      }
    } catch (e) {
      print('Error checking permission: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadData() async {
    try {
      final futures = await Future.wait([
        _appBlockingService.getInstalledApps(),
        _appBlockingService.getBlockRules(childUserId: widget.childUserId ?? 'demo_child_001'),
        _appBlockingService.getBlockAttemptLogs(childUserId: widget.childUserId ?? 'demo_child_001'),
      ]);

      setState(() {
        _installedApps = futures[0] as List<Map<String, dynamic>>;
        _blockRules = futures[1] as List<AppBlockRule>;
        _blockLogs = futures[2] as List<BlockAttemptLog>;
      });
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veri yükleme hatası: $e')),
        );
      }
    }
  }

  Future<void> _requestDeviceAdminPermission() async {
    try {
      await _appBlockingService.requestDeviceAdminPermission();
      // Check permission again after request
      _checkPermissionAndLoadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İzin isteme hatası: $e')),
        );
      }
    }
  }

  Future<void> _toggleAppBlock(String packageName, String appName, bool isBlocked) async {
    try {
      setState(() => _isLoading = true);

      final existingRule = _blockRules.firstWhere(
        (rule) => rule.packageName == packageName,
        orElse: () => AppBlockRule(
          id: '',
          parentUserId: 'demo_parent_001',
          childUserId: widget.childUserId ?? 'demo_child_001',
          packageName: packageName,
          appName: appName,
          appIcon: '',
          isBlocked: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      if (existingRule.id.isEmpty) {
        // Create new rule
        await _appBlockingService.createBlockRule(
          parentUserId: 'demo_parent_001',
          childUserId: widget.childUserId ?? 'demo_child_001',
          packageName: packageName,
          appName: appName,
          appIcon: '',
          isBlocked: isBlocked,
          reason: isBlocked ? 'Ebeveyn tarafından engellendi' : null,
        );
      } else {
        // Update existing rule
        await _appBlockingService.updateBlockRule(
          ruleId: existingRule.id,
          isBlocked: isBlocked,
          reason: isBlocked ? 'Ebeveyn tarafından engellendi' : null,
        );
      }

      await _loadData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isBlocked ? '$appName engellendi' : '$appName engeli kaldırıldı'),
            backgroundColor: isBlocked ? AppColors.error : AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('İşlem hatası: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulama Kilidi'),
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_hasDeviceAdminPermission)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isLoading ? null : _loadData,
            ),
        ],
        bottom: _hasDeviceAdminPermission ? TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Uygulamalar'),
            Tab(text: 'Engellenen'),
            Tab(text: 'Loglar'),
          ],
        ) : null,
      ),
      body: _hasDeviceAdminPermission
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildAppsTab(),
                _buildBlockedAppsTab(),
                _buildLogsTab(),
              ],
            )
          : _buildPermissionRequest(),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 80.w,
              color: AppColors.warning,
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              'Cihaz Yöneticisi İzni Gerekli',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Uygulama kilitleme özelliği için cihaz yöneticisi izni gereklidir. Bu izin, uygulamaları güvenli bir şekilde engellemek için kullanılır.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: _requestDeviceAdminPermission,
              icon: const Icon(Icons.security),
              label: const Text('İzin Ver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_installedApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apps,
              size: 64.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Uygulama bulunamadı',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: _installedApps.length,
      itemBuilder: (context, index) {
        final app = _installedApps[index];
        final packageName = app['packageName'] as String;
        final appName = app['appName'] as String;
        
        final blockRule = _blockRules.firstWhere(
          (rule) => rule.packageName == packageName,
          orElse: () => AppBlockRule(
            id: '',
            parentUserId: '',
            childUserId: '',
            packageName: packageName,
            appName: appName,
            appIcon: '',
            isBlocked: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.apps,
                color: AppColors.primary,
                size: 24.w,
              ),
            ),
            title: Text(
              appName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              packageName,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Switch(
              value: blockRule.isCurrentlyBlocked,
              onChanged: (value) => _toggleAppBlock(packageName, appName, value),
              activeColor: AppColors.error,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlockedAppsTab() {
    final blockedApps = _blockRules.where((rule) => rule.isCurrentlyBlocked).toList();

    if (blockedApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 64.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Engellenen uygulama yok',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: blockedApps.length,
      itemBuilder: (context, index) {
        final rule = blockedApps[index];
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.block,
                color: AppColors.error,
                size: 24.w,
              ),
            ),
            title: Text(
              rule.appName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.packageName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  rule.blockStatusText,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(rule),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogsTab() {
    if (_blockLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Henüz log kaydı yok',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: _blockLogs.length,
      itemBuilder: (context, index) {
        final log = _blockLogs[index];
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: log.wasBlocked 
                    ? AppColors.error.withValues(alpha: 0.1)
                    : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                log.wasBlocked ? Icons.block : Icons.warning,
                color: log.wasBlocked ? AppColors.error : AppColors.warning,
                size: 24.w,
              ),
            ),
            title: Text(
              log.appName,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.blockReason,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  log.formattedAttemptTime,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            trailing: Icon(
              log.wasBlocked ? Icons.check_circle : Icons.cancel,
              color: log.wasBlocked ? AppColors.success : AppColors.error,
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(AppBlockRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Engeli Kaldır'),
        content: Text('${rule.appName} uygulamasının engelini kaldırmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await _appBlockingService.deleteBlockRule(rule.id);
                await _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${rule.appName} engeli kaldırıldı'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hata: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );
  }
} 