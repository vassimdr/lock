import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/permission_service.dart';
import '../../navigation/app_router.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  Map<permission_handler.Permission, permission_handler.PermissionStatus> _permissionStatuses = {};
  bool _usageAccessGranted = false;
  bool _accessibilityGranted = false;
  bool _deviceAdminGranted = false;
  bool _overlayGranted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isLoading = true;
    });

    // Flutter desteklenen izinleri kontrol et
    Map<permission_handler.Permission, permission_handler.PermissionStatus> statuses = {};
    for (final permission in PermissionService.criticalPermissions) {
      statuses[permission] = await permission.status;
    }

    // Native Android izinlerini kontrol et
    final usageAccess = await PermissionService.checkUsageAccessPermission();
    final accessibility = await PermissionService.checkAccessibilityPermission();
    final deviceAdmin = await PermissionService.checkDeviceAdminPermission();
    final overlay = await PermissionService.checkOverlayPermission();

    setState(() {
      _permissionStatuses = statuses;
      _usageAccessGranted = usageAccess;
      _accessibilityGranted = accessibility;
      _deviceAdminGranted = deviceAdmin;
      _overlayGranted = overlay;
      _isLoading = false;
    });
  }

  Future<void> _requestPermission(permission_handler.Permission permission) async {
    final status = await permission.request();
    setState(() {
      _permissionStatuses[permission] = status;
    });
  }

  Future<void> _requestAllPermissions() async {
    setState(() {
      _isLoading = true;
    });

    final statuses = await PermissionService.requestAllPermissions();
    
    setState(() {
      _permissionStatuses = statuses;
      _isLoading = false;
    });
  }

  bool get _allPermissionsGranted {
    final flutterPermissionsGranted = _permissionStatuses.values.every((status) => status.isGranted);
    return flutterPermissionsGranted && _usageAccessGranted && _accessibilityGranted && _deviceAdminGranted && _overlayGranted;
  }

  void _openUsageAccessSettings() async {
    await PermissionService.openUsageAccessSettings();
  }

  void _openAccessibilitySettings() async {
    await PermissionService.openAccessibilitySettings();
  }

  void _openDeviceAdminSettings() async {
    await PermissionService.openDeviceAdminSettings();
  }

  // Popup kaldırıldı - doğrudan ayarlara yönlendiriyoruz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('İzinler'),
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.security,
                            size: 48.w,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Gerekli İzinler',
                            style: AppTextStyles.headline4,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            'Ebeveyn kontrol uygulamasının düzgün çalışması için aşağıdaki izinler gereklidir.',
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    
                    // Arama Rehberi
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppColors.info,
                            size: 24.w,
                          ),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Önemli İpucu!',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.info,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Ayarlar uygulamasında üstteki arama kutusunu kullanın. Bu en kolay yoldur!',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    
                    // Permission List
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Flutter desteklenen izinler
                            ...PermissionService.criticalPermissions.map((permission) {
                              final status = _permissionStatuses[permission] ?? permission_handler.PermissionStatus.denied;
                              return _PermissionCard(
                                permission: permission,
                                status: status,
                                onRequest: () => _requestPermission(permission),
                              );
                            }),
                            
                            // Manuel izinler (ayarlara yönlendirme)
                            _ManualPermissionCard(
                              title: 'Kullanım Erişimi İzni',
                              description: 'Uygulama kullanım istatistiklerini görüntülemek için gerekli',
                              icon: '📊',
                              searchKeywords: 'Kullanım erişimi, Usage access, Uygulama kullanım',
                              isGranted: _usageAccessGranted,
                              helpText: 'Ayarlar açıldıktan sonra:\n• Arama kutusuna "kullanım erişimi" yazın\n• Veya: Uygulamalar → Özel erişim → Kullanım erişimi\n• Veya: Gizlilik → Kullanım erişimi\n• LockApp\'i bulup etkinleştirin',
                              onTap: () async {
                                _openUsageAccessSettings();
                                await _checkPermissions();
                              },
                            ),
                            
                            _ManualPermissionCard(
                              title: 'Erişilebilirlik Servisi İzni',
                              description: 'Diğer uygulamaları kontrol etmek için gerekli',
                              icon: '♿',
                              searchKeywords: 'Erişilebilirlik, Accessibility, Yardımcı teknolojiler',
                              isGranted: _accessibilityGranted,
                              helpText: 'Ayarlar açıldıktan sonra:\n• Arama kutusuna "erişilebilirlik" yazın\n• Veya: Sistem → Erişilebilirlik\n• Veya: Dijital sağlık → Erişilebilirlik\n• LockApp\'i bulup etkinleştirin',
                              onTap: () async {
                                _openAccessibilitySettings();
                                await _checkPermissions();
                              },
                            ),
                            
                            _ManualPermissionCard(
                              title: 'Cihaz Yöneticisi İzni',
                              description: 'Cihaz yönetimi ve kilitleme için gerekli',
                              icon: '🔧',
                              searchKeywords: 'Cihaz yöneticisi, Device admin, Güvenlik, Biometrik',
                              isGranted: _deviceAdminGranted,
                              helpText: 'Ayarlar açıldıktan sonra:\n• Arama kutusuna "cihaz yöneticisi" yazın\n• Veya: Güvenlik → Cihaz yöneticileri\n• Veya: Biyometrik ve güvenlik → Diğer güvenlik\n• LockApp\'i bulup etkinleştirin',
                              onTap: () async {
                                _openDeviceAdminSettings();
                                await _checkPermissions();
                              },
                            ),
                            
                            SizedBox(height: AppSpacing.xl), // Bottom padding
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    
                    // Action Buttons
                    if (!_allPermissionsGranted) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _requestAllPermissions,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Tüm İzinleri İste'),
                        ),
                      ),
                      
                      SizedBox(height: AppSpacing.md),
                      
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => permission_handler.openAppSettings(),
                          child: const Text('Ayarları Aç'),
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => AppRouter.goToParentDashboard(),
                          child: const Text('Devam Et'),
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

// Popup dialog kaldırıldı - doğrudan ayarlara yönlendiriyoruz

class _PermissionCard extends StatelessWidget {
  final permission_handler.Permission permission;
  final permission_handler.PermissionStatus status;
  final VoidCallback onRequest;

  const _PermissionCard({
    required this.permission,
    required this.status,
    required this.onRequest,
  });

  void _openSpecificSettings() async {
    switch (permission) {
      case permission_handler.Permission.systemAlertWindow:
        await PermissionService.openSystemAlertWindowSettings();
        break;
      default:
        await permission_handler.openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGranted = status.isGranted;
    final isDenied = status.isDenied;
    final isPermanentlyDenied = status.isPermanentlyDenied;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  PermissionService.getPermissionIcon(permission),
                  style: TextStyle(fontSize: 24.w),
                ),
              ),
            ),
            
            SizedBox(width: AppSpacing.md),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PermissionService.getPermissionName(permission),
                    style: AppTextStyles.cardTitle,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    PermissionService.getPermissionDescription(permission),
                    style: AppTextStyles.cardSubtitle,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    _getStatusText(status),
                    style: AppTextStyles.caption.copyWith(
                      color: _getStatusColor(status),
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Button
            if (!isGranted)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isPermanentlyDenied)
                    ElevatedButton(
                      onPressed: onRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getStatusColor(status),
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('İste'),
                    ),
                  if (!isPermanentlyDenied) SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () => _openSpecificSettings(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Ayarlar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(permission_handler.PermissionStatus status) {
    switch (status) {
      case permission_handler.PermissionStatus.granted:
        return AppColors.success;
      case permission_handler.PermissionStatus.denied:
        return AppColors.warning;
      case permission_handler.PermissionStatus.permanentlyDenied:
        return AppColors.error;
      case permission_handler.PermissionStatus.restricted:
        return AppColors.error;
      case permission_handler.PermissionStatus.limited:
        return AppColors.warning;
      case permission_handler.PermissionStatus.provisional:
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(permission_handler.PermissionStatus status) {
    switch (status) {
      case permission_handler.PermissionStatus.granted:
        return 'İzin verildi';
      case permission_handler.PermissionStatus.denied:
        return 'İzin reddedildi';
      case permission_handler.PermissionStatus.permanentlyDenied:
        return 'Kalıcı olarak reddedildi';
      case permission_handler.PermissionStatus.restricted:
        return 'Kısıtlandı';
      case permission_handler.PermissionStatus.limited:
        return 'Sınırlı';
      case permission_handler.PermissionStatus.provisional:
        return 'Geçici';
      default:
        return 'Bilinmiyor';
    }
  }
}

class _ManualPermissionCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final String searchKeywords;
  final bool isGranted;
  final VoidCallback onTap;
  final String? helpText;

  const _ManualPermissionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.searchKeywords,
    required this.isGranted,
    required this.onTap,
    this.helpText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: (isGranted ? AppColors.success : AppColors.warning).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 24.w),
                ),
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
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    isGranted ? 'İzin verildi' : 'Manuel ayar gerekli',
                    style: AppTextStyles.caption.copyWith(
                      color: isGranted ? AppColors.success : AppColors.warning,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'Arama: $searchKeywords',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.info,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  if (helpText != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      helpText!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
                                        // Action Buttons
            if (isGranted)
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Kontrol Et'),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title.contains('Erişilebilirlik') || title.contains('Cihaz Yöneticisi'))
                    ElevatedButton(
                      onPressed: () async {
                        if (title.contains('Erişilebilirlik')) {
                          await PermissionService.requestAccessibilityPermission();
                        } else if (title.contains('Cihaz Yöneticisi')) {
                          await PermissionService.requestDeviceAdminPermission();
                        }
                        onTap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                      child: const Text('Otomatik'),
                    ),
                  if (title.contains('Erişilebilirlik') || title.contains('Cihaz Yöneticisi'))
                    SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Manuel'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
} 