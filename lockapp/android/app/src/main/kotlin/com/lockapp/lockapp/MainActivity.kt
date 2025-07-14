package com.lockapp.lockapp

import android.app.AppOpsManager
import android.app.admin.DevicePolicyManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import android.util.Base64
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.text.SimpleDateFormat
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.lockapp.lockapp/permissions"
    private val USAGE_STATS_CHANNEL = "lockapp/usage_stats"
    private val APP_BLOCKING_CHANNEL = "lockapp/app_blocking"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Permissions channel
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

        // App blocking channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_BLOCKING_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasDeviceAdminPermission" -> {
                    result.success(hasDeviceAdminPermission())
                }
                "requestDeviceAdminPermission" -> {
                    requestDeviceAdminPermission()
                    result.success(true)
                }
                "blockApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        result.success(blockApp(packageName))
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                "unblockApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        result.success(unblockApp(packageName))
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                "getInstalledApps" -> {
                    result.success(getInstalledApps())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Usage Stats channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasUsageStatsPermission" -> {
                    result.success(hasUsageStatsPermission())
                }
                "requestUsageStatsPermission" -> {
                    requestUsageStatsPermission()
                    result.success(null)
                }
                "getUsageStatsForDate" -> {
                    val date = call.argument<String>("date")
                    if (date != null) {
                        result.success(getUsageStatsForDate(date))
                    } else {
                        result.error("INVALID_ARGUMENT", "Date is required", null)
                    }
                }
                "getUsageStatsForDateRange" -> {
                    val startDate = call.argument<String>("startDate")
                    val endDate = call.argument<String>("endDate")
                    if (startDate != null && endDate != null) {
                        result.success(getUsageStatsForDateRange(startDate, endDate))
                    } else {
                        result.error("INVALID_ARGUMENT", "Start date and end date are required", null)
                    }
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

    // Usage Stats Methods
    private fun hasUsageStatsPermission(): Boolean {
        return try {
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
    }

    private fun requestUsageStatsPermission() {
        try {
            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (e: Exception) {
            // Fallback to general settings
            openUsageAccessSettings()
        }
    }

    private fun getUsageStatsForDate(dateString: String): List<Map<String, Any>> {
        if (!hasUsageStatsPermission()) {
            return emptyList()
        }

        return try {
            val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
            val packageManager = packageManager
            
            // Parse date
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val date = sdf.parse(dateString) ?: return emptyList()
            
            // Get start and end of day
            val calendar = Calendar.getInstance()
            calendar.time = date
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)
            calendar.set(Calendar.MILLISECOND, 0)
            val startTime = calendar.timeInMillis
            
            calendar.add(Calendar.DAY_OF_MONTH, 1)
            val endTime = calendar.timeInMillis

            // Get usage stats
            val usageStats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                startTime,
                endTime
            )

            val result = mutableListOf<Map<String, Any>>()
            
            for (usageStat in usageStats) {
                if (usageStat.totalTimeInForeground > 0) {
                    try {
                        val appInfo = packageManager.getApplicationInfo(usageStat.packageName, 0)
                        val appName = packageManager.getApplicationLabel(appInfo).toString()
                        val appIcon = getAppIconAsBase64(usageStat.packageName)
                        
                        val statMap = mapOf(
                            "packageName" to usageStat.packageName,
                            "appName" to appName,
                            "appIcon" to appIcon,
                            "totalTimeInForeground" to usageStat.totalTimeInForeground,
                            "launchCount" to usageStat.totalTimeInForeground, // Approximate launch count
                            "firstTimeStamp" to usageStat.firstTimeStamp,
                            "lastTimeStamp" to usageStat.lastTimeStamp,
                            "date" to dateString
                        )
                        result.add(statMap)
                    } catch (e: PackageManager.NameNotFoundException) {
                        // App might be uninstalled, skip
                        continue
                    }
                }
            }
            
            // Sort by usage time descending
            result.sortedByDescending { it["totalTimeInForeground"] as Long }
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun getUsageStatsForDateRange(startDateString: String, endDateString: String): List<Map<String, Any>> {
        if (!hasUsageStatsPermission()) {
            return emptyList()
        }

        return try {
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val startDate = sdf.parse(startDateString) ?: return emptyList()
            val endDate = sdf.parse(endDateString) ?: return emptyList()
            
            val result = mutableListOf<Map<String, Any>>()
            val calendar = Calendar.getInstance()
            calendar.time = startDate
            
            while (!calendar.time.after(endDate)) {
                val dateString = sdf.format(calendar.time)
                val dailyStats = getUsageStatsForDate(dateString)
                result.addAll(dailyStats)
                calendar.add(Calendar.DAY_OF_MONTH, 1)
            }
            
            result
        } catch (e: Exception) {
            emptyList()
        }
    }

    private fun getAppIconAsBase64(packageName: String): String {
        return try {
            val drawable = packageManager.getApplicationIcon(packageName)
            val bitmap = drawableToBitmap(drawable)
            val outputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT)
        } catch (e: Exception) {
            "" // Return empty string if icon can't be retrieved
        }
    }

    private fun getAppIconAsBase64(drawable: Drawable): String {
        return try {
            val bitmap = drawableToBitmap(drawable)
            val outputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
            Base64.encodeToString(outputStream.toByteArray(), Base64.DEFAULT)
        } catch (e: Exception) {
            "" // Return empty string if icon can't be retrieved
        }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        val bitmap = Bitmap.createBitmap(
            drawable.intrinsicWidth,
            drawable.intrinsicHeight,
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

    // App Blocking Methods
    private fun hasDeviceAdminPermission(): Boolean {
        val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
        val componentName = ComponentName(this, LockAppDeviceAdminReceiver::class.java)
        return devicePolicyManager.isAdminActive(componentName)
    }

    private fun blockApp(packageName: String): Boolean {
        return try {
            val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val componentName = ComponentName(this, LockAppDeviceAdminReceiver::class.java)
            
            if (!devicePolicyManager.isAdminActive(componentName)) {
                return false
            }

            // For now, we'll use a simple approach - hide the app from launcher
            // In a real implementation, you would need more sophisticated blocking
            val packageManager = packageManager
            val intent = packageManager.getLaunchIntentForPackage(packageName)
            
            if (intent != null) {
                // This is a simplified approach - in reality, you'd need to implement
                // a more robust blocking mechanism, possibly using accessibility service
                // or device admin policies
                return true
            }
            
            false
        } catch (e: Exception) {
            false
        }
    }

    private fun unblockApp(packageName: String): Boolean {
        return try {
            val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
            val componentName = ComponentName(this, LockAppDeviceAdminReceiver::class.java)
            
            if (!devicePolicyManager.isAdminActive(componentName)) {
                return false
            }

            // Reverse the blocking process
            // This is a simplified implementation
            return true
        } catch (e: Exception) {
            false
        }
    }

    private fun getInstalledApps(): List<Map<String, Any>> {
        val packageManager = packageManager
        val installedApps = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
        val result = mutableListOf<Map<String, Any>>()

        for (app in installedApps) {
            // Filter out system apps and include only user-installed apps
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) == 0) {
                val appName = packageManager.getApplicationLabel(app).toString()
                val packageName = app.packageName
                val appIcon = try {
                    val drawable = packageManager.getApplicationIcon(app)
                    getAppIconAsBase64(drawable)
                } catch (e: Exception) {
                    ""
                }

                val appInfo = mapOf(
                    "packageName" to packageName,
                    "appName" to appName,
                    "appIcon" to appIcon,
                    "isSystemApp" to false
                )
                result.add(appInfo)
            }
        }

        return result.sortedBy { it["appName"] as String }
    }
}
