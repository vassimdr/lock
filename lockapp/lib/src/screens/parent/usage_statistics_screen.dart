import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/usage_stats_service.dart';
import '../../types/app_usage_stats.dart';

class UsageStatisticsScreen extends ConsumerStatefulWidget {
  final String? childUserId;

  const UsageStatisticsScreen({super.key, this.childUserId});

  @override
  ConsumerState<UsageStatisticsScreen> createState() => _UsageStatisticsScreenState();
}

class _UsageStatisticsScreenState extends ConsumerState<UsageStatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UsageStatsService _usageStatsService = UsageStatsService();
  
  List<AppUsageStats> _todayStats = [];
  DailyUsageSummary? _todaySummary;
  WeeklyUsageReport? _weeklyReport;
  bool _isLoading = false;
  bool _hasPermission = false;
  DateTime _selectedDate = DateTime.now();

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
      _hasPermission = await _usageStatsService.hasUsageStatsPermission();
      
      if (_hasPermission) {
        await _loadUsageData();
      }
    } catch (e) {
      print('Error checking permission: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermission() async {
    try {
      await _usageStatsService.requestUsageStatsPermission();
      // After returning from settings, check permission again
      await Future.delayed(const Duration(seconds: 1));
      await _checkPermissionAndLoadData();
    } catch (e) {
      print('Error requesting permission: $e');
    }
  }

  Future<void> _loadUsageData() async {
    if (!_hasPermission) return;
    
    setState(() => _isLoading = true);
    
    try {
      final String childUserId = widget.childUserId ?? 'current_child';
      
      // Load today's data
      _todayStats = await _usageStatsService.getUsageStatsFromFirestore(
        childUserId: childUserId,
        date: _selectedDate,
      );
      
      // Generate daily summary
      _todaySummary = await _usageStatsService.generateDailyUsageSummary(
        childUserId: childUserId,
        date: _selectedDate,
      );
      
      // Generate weekly report
      final DateTime weekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
      _weeklyReport = await _usageStatsService.generateWeeklyUsageReport(
        childUserId: childUserId,
        weekStart: weekStart,
      );
      
    } catch (e) {
      print('Error loading usage data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veri yüklenemedi: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _syncData() async {
    if (!_hasPermission) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Get fresh data from device
      final usageStats = await _usageStatsService.getUsageStatsForDate(_selectedDate);
      
      if (usageStats.isNotEmpty) {
        await _usageStatsService.syncUsageStatsToFirestore(usageStats);
        await _loadUsageData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veriler başarıyla senkronize edildi')),
          );
        }
      }
    } catch (e) {
      print('Error syncing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Senkronizasyon hatası: $e')),
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
        title: const Text('Kullanım İstatistikleri'),
        backgroundColor: AppColors.parentPrimary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_hasPermission)
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _isLoading ? null : _syncData,
            ),
        ],
        bottom: _hasPermission ? TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Bugün'),
            Tab(text: 'Bu Hafta'),
            Tab(text: 'Uygulamalar'),
          ],
        ) : null,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_hasPermission
              ? _buildPermissionView()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTodayView(),
                    _buildWeeklyView(),
                    _buildAppsView(),
                  ],
                ),
    );
  }

  Widget _buildPermissionView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 80.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Kullanım İstatistikleri İzni Gerekli',
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Uygulama kullanım istatistiklerini görebilmek için "Kullanım Erişimi" iznine ihtiyacımız var.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _requestPermission,
                icon: const Icon(Icons.settings),
                label: const Text('İzin Ver'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.parentPrimary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayView() {
    if (_todaySummary == null) {
      return const Center(child: Text('Bugün için veri bulunamadı'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Selector
          _buildDateSelector(),
          SizedBox(height: AppSpacing.lg),
          
          // Summary Cards
          _buildSummaryCards(),
          SizedBox(height: AppSpacing.lg),
          
          // Usage Chart
          _buildUsageChart(),
          SizedBox(height: AppSpacing.lg),
          
          // Top Apps
          _buildTopApps(),
        ],
      ),
    );
  }

  Widget _buildWeeklyView() {
    if (_weeklyReport == null) {
      return const Center(child: Text('Bu hafta için veri bulunamadı'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weekly Summary Cards
          _buildWeeklySummaryCards(),
          SizedBox(height: AppSpacing.lg),
          
          // Weekly Chart
          _buildWeeklyChart(),
          SizedBox(height: AppSpacing.lg),
          
          // Daily Breakdown
          _buildDailyBreakdown(),
        ],
      ),
    );
  }

  Widget _buildAppsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tüm Uygulamalar',
            style: AppTextStyles.headlineSmall,
          ),
          SizedBox(height: AppSpacing.md),
          
          if (_todayStats.isEmpty)
            Center(
              child: Text(
                'Uygulama verisi bulunamadı',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _todayStats.length,
              itemBuilder: (context, index) {
                final app = _todayStats[index];
                return _buildAppTile(app);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.parentPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
              _loadUsageData();
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: AppTextStyles.titleMedium,
          ),
          IconButton(
            onPressed: _selectedDate.isBefore(DateTime.now()) ? () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
              _loadUsageData();
            } : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Toplam Süre',
            _todaySummary!.formattedTotalScreenTime,
            Icons.access_time,
            AppColors.info,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildSummaryCard(
            'Uygulama Sayısı',
            '${_todaySummary!.uniqueAppsUsed}',
            Icons.apps,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.sp),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(color: color),
          ),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageChart() {
    if (_todayStats.isEmpty) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Grafik için veri yok'),
        ),
      );
    }

    return Container(
      height: 300.h,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uygulama Kullanım Dağılımı',
            style: AppTextStyles.titleMedium,
          ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _todayStats.take(5).map((app) {
                  return PieChartSectionData(
                    value: app.totalTimeInForeground.toDouble(),
                    title: '${app.usagePercentage.toStringAsFixed(1)}%',
                    color: _getColorForIndex(_todayStats.indexOf(app)),
                    radius: 60,
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopApps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'En Çok Kullanılan Uygulamalar',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: AppSpacing.md),
        
        if (_todayStats.isEmpty)
          Center(
            child: Text(
              'Uygulama verisi bulunamadı',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todayStats.take(5).length,
            itemBuilder: (context, index) {
              final app = _todayStats[index];
              return _buildAppTile(app);
            },
          ),
      ],
    );
  }

  Widget _buildAppTile(AppUsageStats app) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // App Icon (placeholder for now)
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: _getColorForIndex(_todayStats.indexOf(app)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.apps, color: Colors.white),
          ),
          SizedBox(width: AppSpacing.md),
          
          // App Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.appName,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  app.packageName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Usage Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                app.formattedDuration,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.parentPrimary,
                ),
              ),
              Text(
                '${app.usagePercentage.toStringAsFixed(1)}%',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Haftalık Toplam',
            _weeklyReport!.totalScreenTime > 0 
                ? Duration(milliseconds: _weeklyReport!.totalScreenTime).inHours.toString() + 's'
                : '0s',
            Icons.calendar_view_week,
            AppColors.info,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildSummaryCard(
            'Günlük Ortalama',
            _weeklyReport!.averageDailyScreenTime > 0
                ? Duration(milliseconds: _weeklyReport!.averageDailyScreenTime).inHours.toString() + 's'
                : '0s',
            Icons.access_time,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Haftalık Kullanım Trendi',
            style: AppTextStyles.titleMedium,
          ),
          SizedBox(height: AppSpacing.md),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _weeklyReport!.dailySummaries.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.totalScreenTime.toDouble() / 3600000, // Convert to hours
                      );
                    }).toList(),
                    isCurved: true,
                    color: AppColors.parentPrimary,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Günlük Detaylar',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: AppSpacing.md),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _weeklyReport!.dailySummaries.length,
          itemBuilder: (context, index) {
            final summary = _weeklyReport!.dailySummaries[index];
            const days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
            
            return Container(
              margin: EdgeInsets.only(bottom: AppSpacing.sm),
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        days[summary.date.weekday - 1],
                        style: AppTextStyles.titleSmall,
                      ),
                      Text(
                        '${summary.date.day}/${summary.date.month}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        summary.formattedTotalScreenTime,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.parentPrimary,
                        ),
                      ),
                      Text(
                        '${summary.uniqueAppsUsed} uygulama',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getColorForIndex(int index) {
    const colors = [
      AppColors.parentPrimary,
      AppColors.childPrimary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }
} 