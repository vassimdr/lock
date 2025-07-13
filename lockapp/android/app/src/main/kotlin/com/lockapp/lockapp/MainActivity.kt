package com.lockapp.lockapp

import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.lockapp.lockapp/permissions"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openUsageAccessSettings" -> {
                    openUsageAccessSettings()
                    result.success(true)
                }
                "openAccessibilitySettings" -> {
                    openAccessibilitySettings()
                    result.success(true)
                }
                "openDeviceAdminSettings" -> {
                    openDeviceAdminSettings()
                    result.success(true)
                }
                "openOverlaySettings" -> {
                    openOverlaySettings()
                    result.success(true)
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(true)
                }
                "checkUsageAccessPermission" -> {
                    result.success(checkUsageAccessPermission())
                }
                "checkAccessibilityPermission" -> {
                    result.success(checkAccessibilityPermission())
                }
                "checkDeviceAdminPermission" -> {
                    result.success(checkDeviceAdminPermission())
                }
                "checkOverlayPermission" -> {
                    result.success(checkOverlayPermission())
                }
                "requestAccessibilityPermission" -> {
                    requestAccessibilityPermission()
                    result.success(true)
                }
                "requestDeviceAdminPermission" -> {
                    requestDeviceAdminPermission()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun openUsageAccessSettings() {
        val intents = listOf(
            // Ana usage access settings
            Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS),
            // Uygulama özel usage access
            Intent("android.settings.USAGE_ACCESS_SETTINGS").apply {
                data = Uri.parse("package:$packageName")
            },
            // Alternatif yollar
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:$packageName")
            }
        )
        
        tryIntents(intents)
    }

    private fun openAccessibilitySettings() {
        val intents = listOf(
            // Ana accessibility settings
            Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS),
            // Sistem ayarları altında erişilebilirlik
            Intent("android.settings.ACCESSIBILITY_SETTINGS"),
            // Dijital sağlık ve ebeveyn denetimleri
            Intent("android.settings.DIGITAL_WELLBEING_SETTINGS"),
            // Sistem ayarları
            Intent("android.settings.SYSTEM_SETTINGS"),
            // Genel ayarlar (arama yapabilir)
            Intent(Settings.ACTION_SETTINGS)
        )
        
        tryIntents(intents)
    }

    private fun openDeviceAdminSettings() {
        val intents = listOf(
            // Ana güvenlik ayarları
            Intent(Settings.ACTION_SECURITY_SETTINGS),
            // Cihaz yöneticileri (bazı cihazlarda)
            Intent("android.settings.DEVICE_ADMIN_SETTINGS"),
            // Biometrik ve güvenlik
            Intent("android.settings.BIOMETRIC_ENROLL"),
            // Güvenlik ve gizlilik
            Intent("android.settings.PRIVACY_SETTINGS"),
            // Biyometrik ayarlar
            Intent("android.settings.FINGERPRINT_ENROLL"),
            // Ekran kilidi ayarları
            Intent("android.settings.SECURITY_SETTINGS"),
            // Genel ayarlar (arama yapabilir)
            Intent(Settings.ACTION_SETTINGS)
        )
        
        tryIntents(intents)
    }

    private fun openOverlaySettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intents = listOf(
                // Ana overlay permission
                Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION).apply {
                    data = Uri.parse("package:$packageName")
                },
                // Genel overlay ayarları
                Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION),
                // Uygulama ayarları
                Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.parse("package:$packageName")
                }
            )
            
            tryIntents(intents)
        } else {
            openAppSettings()
        }
    }

    private fun openAppSettings() {
        val intents = listOf(
            // Uygulama detay ayarları
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:$packageName")
            },
            // Uygulama yöneticisi
            Intent(Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS),
            // Genel ayarlar
            Intent(Settings.ACTION_SETTINGS)
        )
        
        tryIntents(intents)
    }

    private fun tryIntents(intents: List<Intent>) {
        for (intent in intents) {
            try {
                // Intent'in çözülebilir olup olmadığını kontrol et
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    return
                }
            } catch (e: Exception) {
                // Bu intent çalışmadı, bir sonrakini dene
                continue
            }
        }
        
        // Hiçbiri çalışmadıysa, en son çare olarak genel ayarları aç
        try {
            val fallbackIntent = Intent(Settings.ACTION_SETTINGS)
            startActivity(fallbackIntent)
        } catch (e: Exception) {
            // Bu da çalışmadıysa, hiçbir şey yapma
        }
    }

    // İzin kontrol metodları
    private fun checkUsageAccessPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            try {
                val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
                val mode = appOpsManager.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    android.os.Process.myUid(),
                    packageName
                )
                mode == AppOpsManager.MODE_ALLOWED
            } catch (e: Exception) {
                false
            }
        } else {
            true // Eski Android sürümlerinde bu izin yok
        }
    }

    private fun checkAccessibilityPermission(): Boolean {
        return try {
            val enabledServices = Settings.Secure.getString(
                contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            )
            
            if (enabledServices.isNullOrEmpty()) {
                false
            } else {
                val colonSplitter = TextUtils.SimpleStringSplitter(':')
                colonSplitter.setString(enabledServices)
                
                while (colonSplitter.hasNext()) {
                    val componentName = colonSplitter.next()
                    if (componentName.contains("$packageName.LockAppAccessibilityService", ignoreCase = true)) {
                        return true
                    }
                }
                false
            }
        } catch (e: Exception) {
            false
        }
    }

    private fun checkDeviceAdminPermission(): Boolean {
        return try {
            val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val componentName = ComponentName(this, LockAppDeviceAdminReceiver::class.java)
            devicePolicyManager.isAdminActive(componentName)
        } catch (e: Exception) {
            false
        }
    }

    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true // Eski Android sürümlerinde bu izin yok
        }
    }

    // Otomatik izin isteme metodları
    private fun requestAccessibilityPermission() {
        try {
            val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (e: Exception) {
            // Fallback
            openAccessibilitySettings()
        }
    }

    private fun requestDeviceAdminPermission() {
        try {
            val componentName = ComponentName(this, LockAppDeviceAdminReceiver::class.java)
            val intent = Intent(DevicePolicyManager.ACTION_ADD_DEVICE_ADMIN)
            intent.putExtra(DevicePolicyManager.EXTRA_DEVICE_ADMIN, componentName)
            intent.putExtra(DevicePolicyManager.EXTRA_ADD_EXPLANATION, getString(R.string.device_admin_description))
            startActivity(intent)
        } catch (e: Exception) {
            // Fallback
            openDeviceAdminSettings()
        }
    }
}
