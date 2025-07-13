import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/qr_pairing_service.dart';
import '../../navigation/app_router.dart';
import '../../types/user_model.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  final QrPairingService _qrService = QrPairingService();
  final MobileScannerController _controller = MobileScannerController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _manualCodeController = TextEditingController();
  
  bool _isProcessing = false;
  bool _showManualEntry = false;
  String? _scannedCode;

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  Future<void> _processQrCode(String code) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _scannedCode = code;
    });

    try {
      // Show name input dialog
      final childName = await _showNameInputDialog();
      if (childName == null || childName.isEmpty) {
        setState(() => _isProcessing = false);
        return;
      }

      // Accept pairing request
      final childUser = await _qrService.acceptPairingRequest(
        qrCode: code,
        childName: childName,
        childDeviceId: 'child_device_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) {
        // Show success and navigate to child dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eşleştirme başarılı! Hoş geldin ${childUser.name}'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Navigate to child dashboard
        AppRouter.goToChildDashboard();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eşleştirme hatası: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<String?> _showNameInputDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('İsminizi Girin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Eşleştirme için isminizi girin:'),
            SizedBox(height: AppSpacing.md),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'İsim',
                hintText: 'Örn: Ahmet',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(context, name);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.childPrimary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Devam'),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty && !_isProcessing) {
      final code = capture.barcodes.first.rawValue;
      if (code != null) {
        _processQrCode(code);
      }
    }
  }

  void _processManualCode() {
    final code = _manualCodeController.text.trim();
    if (code.isNotEmpty) {
      _processQrCode(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kod Tarat'),
        backgroundColor: AppColors.childPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showManualEntry ? Icons.qr_code_scanner : Icons.keyboard),
            onPressed: () {
              setState(() => _showManualEntry = !_showManualEntry);
            },
          ),
        ],
      ),
      body: _isProcessing
          ? _buildProcessingView()
          : _showManualEntry
              ? _buildManualEntryView()
              : _buildScannerView(),
    );
  }

  Widget _buildProcessingView() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.childPrimary),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Eşleştirme yapılıyor...',
            style: AppTextStyles.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.md),
          if (_scannedCode != null)
            Text(
              'QR Kod: $_scannedCode',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildManualEntryView() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.childPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.keyboard,
                  size: 48.sp,
                  color: AppColors.childPrimary,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'QR Kodu Manuel Girin',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.childPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Ebeveynin gösterdiği QR kodunu yazın',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(height: AppSpacing.xl),
          
          // Manual Input
          TextField(
            controller: _manualCodeController,
            decoration: InputDecoration(
              labelText: 'QR Kod',
              hintText: 'Örn: ABC123XY',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.qr_code),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _manualCodeController.clear(),
              ),
            ),
            textCapitalization: TextCapitalization.characters,
            onSubmitted: (_) => _processManualCode(),
          ),
          
          SizedBox(height: AppSpacing.lg),
          
          // Submit Button
          ElevatedButton.icon(
            onPressed: _processManualCode,
            icon: const Icon(Icons.send),
            label: const Text('Eşleştir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.childPrimary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return Column(
      children: [
        // Instructions
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.lg),
          color: AppColors.childPrimary.withOpacity(0.1),
          child: Column(
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 48.sp,
                color: AppColors.childPrimary,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'QR Kodu Tarat',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.childPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Kamerayı ebeveynin gösterdiği QR koda doğrultun',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Scanner
        Expanded(
          child: Stack(
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
              
              // Overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Container(
                    width: 250.sp,
                    height: 250.sp,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.childPrimary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.childPrimary.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Bottom Actions
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => _controller.toggleTorch(),
                icon: const Icon(Icons.flash_on),
                iconSize: 32.sp,
                color: AppColors.childPrimary,
              ),
              IconButton(
                onPressed: () => _controller.switchCamera(),
                icon: const Icon(Icons.camera_rear),
                iconSize: 32.sp,
                color: AppColors.childPrimary,
              ),
              IconButton(
                onPressed: () {
                  setState(() => _showManualEntry = true);
                },
                icon: const Icon(Icons.keyboard),
                iconSize: 32.sp,
                color: AppColors.childPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 