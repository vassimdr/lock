import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lockapp/src/theme/app_colors.dart';
import 'package:lockapp/src/theme/app_spacing.dart';
import 'package:lockapp/src/theme/app_text_styles.dart';
import 'package:lockapp/src/types/app_control_models.dart';
import 'package:lockapp/src/services/time_restriction_service.dart';
import 'package:lockapp/src/services/app_blocking_service.dart';

class TimeRestrictionScreen extends ConsumerStatefulWidget {
  const TimeRestrictionScreen({super.key});

  @override
  ConsumerState<TimeRestrictionScreen> createState() => _TimeRestrictionScreenState();
}

class _TimeRestrictionScreenState extends ConsumerState<TimeRestrictionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TimeRestrictionService _timeRestrictionService = TimeRestrictionService();
  final AppBlockingService _appBlockingService = AppBlockingService();

  List<TimeRestriction> _restrictions = [];
  List<Map<String, dynamic>> _installedApps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final restrictions = await _timeRestrictionService.getActiveTimeRestrictions();
      final apps = await _appBlockingService.getInstalledApps();
      
      setState(() {
        _restrictions = restrictions;
        _installedApps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Veriler yüklenirken hata oluştu: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Zaman Kısıtlamaları',
          style: AppTextStyles.titleMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.parentPrimary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Aktif Kısıtlamalar'),
            Tab(text: 'Yeni Kısıtlama'),
            Tab(text: 'Geçmiş'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActiveRestrictionsTab(),
                _buildNewRestrictionTab(),
                _buildHistoryTab(),
              ],
            ),
    );
  }

  Widget _buildActiveRestrictionsTab() {
    if (_restrictions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 80.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: AppSpacing.medium),
            Text(
              'Henüz zaman kısıtlaması yok',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: AppSpacing.small),
            Text(
              'Uygulamalar için zaman kısıtlaması ekleyin',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: EdgeInsets.all(AppSpacing.medium),
        itemCount: _restrictions.length,
        itemBuilder: (context, index) {
          final restriction = _restrictions[index];
          return _buildRestrictionCard(restriction);
        },
      ),
    );
  }

  Widget _buildRestrictionCard(TimeRestriction restriction) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.medium),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.parentPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.apps,
                    color: AppColors.parentPrimary,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restriction.appName,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        restriction.packageName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: restriction.isEnabled,
                  onChanged: (value) => _toggleRestriction(restriction.id, value),
                  activeColor: AppColors.parentPrimary,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.medium),
            _buildRestrictionDetails(restriction),
            SizedBox(height: AppSpacing.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _editRestriction(restriction),
                  icon: const Icon(Icons.edit),
                  label: const Text('Düzenle'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteRestriction(restriction.id),
                  icon: const Icon(Icons.delete),
                  label: const Text('Sil'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestrictionDetails(TimeRestriction restriction) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.small),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildDetailRow('Günlük Limit', restriction.formattedDailyLimit),
          _buildDetailRow('İzin Verilen Günler', restriction.allowedDaysText),
          _buildDetailRow('Zaman Aralığı', '${restriction.startTime} - ${restriction.endTime}'),
          _buildDetailRow('Durum', restriction.isEnabled ? 'Aktif' : 'Pasif'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewRestrictionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Yeni Zaman Kısıtlaması',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.medium),
          _buildNewRestrictionForm(),
        ],
      ),
    );
  }

  Widget _buildNewRestrictionForm() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Uygulama Seçin',
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.small),
            if (_installedApps.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                height: 200.h,
                child: ListView.builder(
                  itemCount: _installedApps.length,
                  itemBuilder: (context, index) {
                    final app = _installedApps[index];
                    return ListTile(
                      leading: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.parentPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.apps,
                          color: AppColors.parentPrimary,
                          size: 24.w,
                        ),
                      ),
                      title: Text(app['appName']),
                      subtitle: Text(app['packageName']),
                      onTap: () => _showRestrictionDialog(app),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: AppSpacing.medium),
          Text(
            'Geçmiş Veriler',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: AppSpacing.small),
          Text(
            'Zaman kısıtlama geçmişi burada görünecek',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showRestrictionDialog(Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (context) => _RestrictionDialog(
        app: app,
        onSave: (restriction) async {
          try {
            await _timeRestrictionService.createOrUpdateTimeRestriction(
              parentUserId: 'parent1', // This should come from auth
              childUserId: 'child1', // This should come from selected child
              packageName: restriction['packageName'],
              appName: restriction['appName'],
              dailyTimeLimit: restriction['dailyTimeLimit'],
              allowedDays: restriction['allowedDays'],
              startTime: restriction['startTime'],
              endTime: restriction['endTime'],
            );
            _showSuccessSnackBar('Zaman kısıtlaması oluşturuldu');
            _loadData();
          } catch (e) {
            _showErrorSnackBar('Kısıtlama oluşturulamadı: $e');
          }
        },
      ),
    );
  }

  void _toggleRestriction(String restrictionId, bool isEnabled) async {
    try {
      await _timeRestrictionService.toggleTimeRestriction(restrictionId, isEnabled);
      _showSuccessSnackBar(isEnabled ? 'Kısıtlama aktifleştirildi' : 'Kısıtlama devre dışı bırakıldı');
      _loadData();
    } catch (e) {
      _showErrorSnackBar('Kısıtlama durumu değiştirilemedi: $e');
    }
  }

  void _editRestriction(TimeRestriction restriction) {
    // TODO: Implement edit functionality
    _showErrorSnackBar('Düzenleme özelliği yakında eklenecek');
  }

  void _deleteRestriction(String restrictionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kısıtlamayı Sil'),
        content: const Text('Bu zaman kısıtlamasını silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _timeRestrictionService.deleteTimeRestriction(restrictionId);
        _showSuccessSnackBar('Zaman kısıtlaması silindi');
        _loadData();
      } catch (e) {
        _showErrorSnackBar('Kısıtlama silinemedi: $e');
      }
    }
  }
}

class _RestrictionDialog extends StatefulWidget {
  final Map<String, dynamic> app;
  final Function(Map<String, dynamic>) onSave;

  const _RestrictionDialog({
    required this.app,
    required this.onSave,
  });

  @override
  State<_RestrictionDialog> createState() => _RestrictionDialogState();
}

class _RestrictionDialogState extends State<_RestrictionDialog> {
  int _dailyTimeLimit = 60; // minutes
  List<int> _allowedDays = [1, 2, 3, 4, 5]; // Monday to Friday (consistent with our 0-6 format where Sunday=0)
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  final List<String> _dayNames = [
    'Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.app['appName']} için Kısıtlama'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Günlük Zaman Limiti (dakika)'),
            Slider(
              value: _dailyTimeLimit.toDouble(),
              min: 15,
              max: 480, // 8 hours
              divisions: 31,
              label: '$_dailyTimeLimit dakika',
              onChanged: (value) {
                setState(() => _dailyTimeLimit = value.toInt());
              },
            ),
            SizedBox(height: AppSpacing.medium),
            Text('İzin Verilen Günler'),
            Wrap(
              spacing: 8,
              children: List.generate(7, (index) {
                final isSelected = _allowedDays.contains(index);
                return FilterChip(
                  label: Text(_dayNames[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _allowedDays.add(index);
                      } else {
                        _allowedDays.remove(index);
                      }
                    });
                  },
                );
              }),
            ),
            SizedBox(height: AppSpacing.medium),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Başlangıç Saati'),
                      TextButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (time != null) {
                            setState(() => _startTime = time);
                          }
                        },
                        child: Text(_startTime.format(context)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bitiş Saati'),
                      TextButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (time != null) {
                            setState(() => _endTime = time);
                          }
                        },
                        child: Text(_endTime.format(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _allowedDays.isEmpty ? null : () {
            final restriction = {
              'packageName': widget.app['packageName'],
              'appName': widget.app['appName'],
              'dailyTimeLimit': _dailyTimeLimit,
              'allowedDays': _allowedDays,
              'startTime': '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
              'endTime': '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
            };
            widget.onSave(restriction);
            Navigator.pop(context);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
} 