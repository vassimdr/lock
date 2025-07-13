import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/qr_pairing_service.dart';
import '../../types/pairing_request.dart';
import '../../navigation/app_router.dart';

class QrGenerationScreen extends ConsumerStatefulWidget {
  const QrGenerationScreen({super.key});

  @override
  ConsumerState<QrGenerationScreen> createState() => _QrGenerationScreenState();
}

class _QrGenerationScreenState extends ConsumerState<QrGenerationScreen> {
  final QrPairingService _qrService = QrPairingService();
  PairingRequest? _currentRequest;
  bool _isLoading = false;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadActivePairingRequests();
  }

  Future<void> _loadActivePairingRequests() async {
    setState(() => _isLoading = true);
    try {
      final requests = await _qrService.getActivePairingRequests();
      if (requests.isNotEmpty) {
        setState(() => _currentRequest = requests.first);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateQrCode() async {
    setState(() => _isGenerating = true);
    try {
      final request = await _qrService.generatePairingRequest(
        parentName: 'Parent User', // TODO: Get from auth state
        parentDeviceId: 'parent_device_123', // TODO: Get from device info
      );
      setState(() => _currentRequest = request);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR kod oluşturulamadı: $e')),
        );
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _deleteQrCode() async {
    if (_currentRequest == null) return;
    
    try {
      await _qrService.deletePairingRequest(_currentRequest!.id);
      setState(() => _currentRequest = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR kod silindi')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  void _copyQrCode() {
    if (_currentRequest != null) {
      Clipboard.setData(ClipboardData(text: _currentRequest!.qrCode));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR kod kopyalandı')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çocuk Cihazı Eşleştir'),
        backgroundColor: AppColors.parentPrimary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Icon(
                    Icons.qr_code_2,
                    size: 64.sp,
                    color: AppColors.parentPrimary,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Çocuk Cihazını Eşleştir',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.parentPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Çocuğunuzun cihazında QR kodu taratarak eşleştirme yapın',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // QR Code Section
                  if (_currentRequest != null) ...[
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // QR Code
                          QrImageView(
                            data: _currentRequest!.qrCode,
                            version: QrVersions.auto,
                            size: 200.sp,
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(height: AppSpacing.md),
                          
                          // QR Code Text
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentRequest!.qrCode,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    fontFamily: 'monospace',
                                    letterSpacing: 2,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.sm),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: _copyQrCode,
                                  tooltip: 'Kopyala',
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: AppSpacing.md),
                          
                          // Expiry Info
                          Text(
                            'Geçerlilik: ${_formatDateTime(_currentRequest!.expiresAt)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _deleteQrCode,
                            icon: const Icon(Icons.delete),
                            label: const Text('Sil'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: BorderSide(color: AppColors.error),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isGenerating ? null : _generateQrCode,
                            icon: _isGenerating
                                ? SizedBox(
                                    width: 16.sp,
                                    height: 16.sp,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.refresh),
                            label: const Text('Yenile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.parentPrimary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // No QR Code State
                    Container(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 80.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Henüz QR kod oluşturulmadı',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.lg),
                    
                    // Generate Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isGenerating ? null : _generateQrCode,
                        icon: _isGenerating
                            ? SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.qr_code_2),
                        label: const Text('QR Kod Oluştur'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.parentPrimary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                      ),
                    ),
                  ],
                  
                  SizedBox(height: AppSpacing.xl),
                  
                  // Instructions
                  Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.parentPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nasıl Kullanılır?',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.parentPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _buildInstruction('1', 'QR kod oluşturun'),
                        _buildInstruction('2', 'Çocuğunuzun cihazında LockApp\'i açın'),
                        _buildInstruction('3', 'QR kodu taratın'),
                        _buildInstruction('4', 'Eşleştirme tamamlandı!'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInstruction(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 24.sp,
            height: 24.sp,
            decoration: BoxDecoration(
              color: AppColors.parentPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 