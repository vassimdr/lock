package com.lockapp.lockapp

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent

class LockAppDeviceAdminReceiver : DeviceAdminReceiver() {
    
    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        // Cihaz yöneticisi etkinleştirildiğinde
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        // Cihaz yöneticisi devre dışı bırakıldığında
    }
} 